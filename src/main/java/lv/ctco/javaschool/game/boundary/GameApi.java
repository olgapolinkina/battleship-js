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

    @POST
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/cells")
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

    @GET
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/turn")
    public GameDto getPlayerTurnSettings() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getOpenGameFor(currentUser);
        return game.map(g->{
            GameDto dto = new GameDto();
            dto.setStatus( g.getStatus());
            dto.setPlayerActive( g.isPlayerActive(currentUser) );
            return dto;
        }).orElseThrow(IllegalStateException::new);
    }

    @GET
    @RolesAllowed({"ADMIN", "USER"})
    @Path("/cells")
    public String getShipsPlacementList() {
        User currentUser = userStore.getCurrentUser();
        Optional<Game> game = gameStore.getOpenGameFor(currentUser);
        return game.map(g->{
            List<CellStateDto> dto = gameStore.getCellsForCurrentUser(g, currentUser);
            return new Gson().toJson(dto);
        }).orElseThrow(IllegalStateException::new);
    }




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

            g.setPlayer1Active( !g.isPlayer1Active() );
            g.setPlayer2Active( !g.isPlayer2Active() );
        });
    }


}
