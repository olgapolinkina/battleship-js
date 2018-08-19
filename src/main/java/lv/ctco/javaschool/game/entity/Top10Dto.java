package lv.ctco.javaschool.game.entity;

import lombok.Data;

@Data
public class Top10Dto {
    private int place;
    private String userName;
    private int hitCount;

    public Top10Dto() {
        this.userName="1";
        this.userName="";
        this.hitCount=0;
    }

    public Top10Dto(int number, String name, int count) {
        this.place=number;
        this.userName=name;
        this.hitCount=count;
    }
}
