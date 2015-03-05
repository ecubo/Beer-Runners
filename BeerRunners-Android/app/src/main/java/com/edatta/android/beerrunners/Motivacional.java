package com.edatta.android.beerrunners;

public class Motivacional {

    private Object url;
    private String urlStr;
    private boolean isHardCoded;
    private boolean isFav;

    public Motivacional(Object url, String urlStr, boolean isHardCoded, boolean isFav) {
        this.url = url;
        this.urlStr = urlStr;
        this.isHardCoded = isHardCoded;
        this.isFav = isFav;
    }

    public Object getUrl() {
        return url;
    }

    public void setUrl(Object url) {
        this.url = url;
    }

    public String getUrlStr() {
        return urlStr;
    }

    public void setUrlStr(String urlStr) {
        this.urlStr = urlStr;
    }

    public boolean isHardCoded() {
        return isHardCoded;
    }

    public void setHardCoded(boolean isHardCoded) {
        this.isHardCoded = isHardCoded;
    }

    public boolean isFav() {
        return isFav;
    }

    public void setFav(boolean isFav) {
        this.isFav = isFav;
    }
}
