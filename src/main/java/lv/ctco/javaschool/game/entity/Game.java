package lv.ctco.javaschool.game.entity;

import lombok.Data;
import lv.ctco.javaschool.auth.entity.domain.User;

import javax.persistence.*;

@Data
@Entity
public class Game {
    @Id
    @GeneratedValue
    private Long id;

    @ManyToOne
    private User player1;
    private boolean player1Active;

    @ManyToOne
    private User player2;
    private boolean player2Active;

    @Enumerated(EnumType.STRING)
    private GameStatus status;

    private int TotalVictoryHits;

    public boolean isPlayerActive(User player) {
        if (player.equals(player1)) {
            return player1Active;
        } else if (player.equals(player2)) {
            return player2Active;
        } else {
            throw new IllegalArgumentException();
        }
    }

    public void setPlayerActive(User player, boolean isActive) {
        if (player.equals(player1)) {
            player1Active = isActive;
        } else if (player.equals(player2)) {
            player2Active = isActive;
        } else {
            throw new IllegalArgumentException();
        }
    }

    public User getRivalTo(User player) {
        if (getPlayer1().equals(player)) {
            return getPlayer2();
        } else {
            return getPlayer1();
        }
    }


}
