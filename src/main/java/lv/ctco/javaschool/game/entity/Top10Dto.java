package lv.ctco.javaschool.game.entity;

import lombok.Data;

@Data
public class Top10Dto {
    private String userName;
    private int hitCount;

    public Top10Dto() {
        this.userName="";
        this.hitCount=0;
    }

    public Top10Dto(String name, int count) {
        this.userName=name;
        this.hitCount=count;
    }
}
