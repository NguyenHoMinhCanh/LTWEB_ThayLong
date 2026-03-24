package com.japansport.model;

public class Banner {
    private int id;
    private String image_url;
    private String link;
    private String title;
    private int active;
    private String position; // <-- thêm

    public Banner() {
    }

    public Banner(int id, String image_url, String link,
                  String title, int active, String position) {
        this.id = id;
        this.image_url = image_url;
        this.link = link;
        this.title = title;
        this.active = active;
        this.position = position;
    }

    // getter / setter...

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getImage_url() { return image_url; }
    public void setImage_url(String image_url) { this.image_url = image_url; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getActive() { return active; }
    public void setActive(int active) { this.active = active; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
}
