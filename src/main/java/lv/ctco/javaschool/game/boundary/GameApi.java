package lv.ctco.javaschool.game.boundary;


import com.google.gson.Gson;
import lombok.extern.java.Log;
import lv.ctco.javaschool.auth.control.UserStore;
import lv.ctco.javaschool.auth.entity.domain.User;
import lv.ctco.javaschool.game.control.GameStore;
import lv.ctco.javaschool.game.entity.*;

import javax.annotation.security.RolesAllowed;
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonString;
import javax.json.JsonValue;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Path("/game")
@Stateless
@Log
public class GameApi {
    @PersistenceContext
    private EntityManager em;
    @Inject
    private UserStore userStore;
    @Inject
    private GameStore gameStore;

    /*      for start.jsp
     * Add player to existing game or creates a new one     */
    @POST
    @RolesAllowed({"ADMIN", "USER"})
    public void startGame() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getIncompleteGame();

        game.ifPresent(g -> {
            g.setPlayer2(currentUser);
            g.setStatus(GameStatus.PLACEMENT);
            g.setPlayer1Active(true);
            g.setPlayer2Active(true);
        });

        if (!game.isPresent()) {
            Game newGame = new Game();
            newGame.setPlayer1(currentUser);
            newGame.setStatus(GameStatus.INCOMPLETE);
            em.persist(newGame);
        }
    }

    /*      for placement.jsp
     * Saves to DB player ships     */
    @POST
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/saveships")
    public void setShips(JsonObject field) {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getStartedGameFor(currentUser, GameStatus.PLACEMENT);
        game.ifPresent(g -> {
            if (g.isPlayerActive(currentUser)) {
                List<String> ships = new ArrayList<>();
                for (Map.Entry<String, JsonValue> pair : field.entrySet()) {
                    log.info(pair.getKey() + " - " + pair.getValue());
                    String addr = pair.getKey();
                    String value = ((JsonString) pair.getValue()).getString();
                    if ("SHIP".equals(value)){
                        ships.add(addr);
                    }
                }
                gameStore.setShips(g, currentUser, false, ships);
                g.setPlayerActive(currentUser, false);
                if (!g.isPlayer1Active() && !g.isPlayer2Active()){
                    g.setStatus(GameStatus.STARTED);
                    g.setPlayer1Active(true);
                    g.setPlayer2Active(false);
                }

            }
        });
    }

    /*      for placement.jsp
     * Responsible for waiting for other player and fill of game board     */
    @GET
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/status")
    public GameDto getGameStatus() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getOpenGameFor(currentUser);
        return game.map(g->{
            GameDto dto = new GameDto();
            dto.setStatus( g.getStatus());
            dto.setPlayerActive( g.isPlayerActive(currentUser) );
            return dto;
        }).orElseThrow(IllegalStateException::new);
    }

    /*      for game.jsp & result.jsp
     * Return Game status and which player's turn to fire      */
    @GET
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/turn")
    public GameDto getPlayerTurnSettings() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getLastGameFor(currentUser);
        return game.map(g->{
            GameDto dto = new GameDto();
            dto.setStatus( g.getStatus());
            dto.setPlayerActive( g.isPlayerActive(currentUser) );
            return dto;
        }).orElseThrow(IllegalStateException::new);
    }

    /*      for game.jsp &
     * Return All marks for ships, misses and hits for player     */
    @GET
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/markers")
    public String getUserMarksList() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getOpenGameFor(currentUser);
        return game.map(g->{
            List<CellStateDto> dto = gameStore.getCellsForCurrentUser(g, currentUser);
            return new Gson().toJson(dto);
        }).orElseThrow(IllegalStateException::new);
    }

    /*      for game.jsp
     * Marks result of fire in DB      */
    @POST
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/fire/{address}")
    public void markFirePosistion(@PathParam("address") String address) {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getOpenGameFor(currentUser);
        game.ifPresent(g->{
            User rivalUser = g.getRivalTo(currentUser);
            Optional<Cell> rivalCell = gameStore.getCellStatus(g, rivalUser, address,false);
            CellState rivalCellState;
            if (rivalCell.isPresent()) {
                rivalCellState = rivalCell.get().getState();
            } else { rivalCellState = CellState.EMPTY; }

            if (rivalCellState.equals(CellState.EMPTY)) {
                gameStore.setCellState(g,currentUser,address,true,CellState.MISS);
                gameStore.setCellState(g,rivalUser,address,false,CellState.MISS);
            } else if (rivalCellState.equals(CellState.SHIP)) {
                gameStore.setCellState(g,currentUser,address,true,CellState.HIT);
                rivalCell.get().setState(CellState.HIT);
            }

            if (gameStore.isAllShipsHit(g,rivalUser)) {
                gameStore.uniteAllMarkers(g, currentUser);
                gameStore.uniteAllMarkers(g, rivalUser);
                g.setStatus(GameStatus.FINISHED);
            } else {
                if (rivalCellState.equals(CellState.SHIP)) return;
                g.setPlayer1Active(!g.isPlayer1Active());
                g.setPlayer2Active(!g.isPlayer2Active());
            }
        });
    }

    /*      for result.jsp
     * Return All marks for ships, misses and hits for player     */
    @GET
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/result")
    public String getAllMarksList() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getLastGameFor(currentUser);
        return game.map(g->{
            List<CellStateDto> dto = gameStore.getCellsForCurrentUser(g, currentUser);
            return new Gson().toJson(dto);
        }).orElseThrow(IllegalStateException::new);
    }
}
