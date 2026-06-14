{
  flake.homeModules.news.programs.newsboat = {
    enable = true;
    extraConfig = ''
      cleanup-on-quit yes
      datetime-format "+0%F"
      refresh-on-startup yes
      show-read-articles no
      show-read-feeds no
      text-width 120
    '';
    urls = [
      { url = "http://blog.erlang.org/feed.xml"; }
      { url = "http://joeduffyblog.com/feed.xml"; }
      { url = "http://willgallego.com/feed/"; }
      { url = "https://akkartik.name/feed"; }
      { url = "https://blog.janestreet.com/feed.xml"; }
      { url = "https://blog.plover.com/index.atom"; }
      { url = "https://feeds.feedburner.com/GDBcode"; }
      { url = "https://kubernetes.io/feed.xml"; }
      { url = "https://newsboat.org/news.atom"; }
      { url = "https://nixos.org/news-rss.xml"; }
      { url = "https://rachelbythebay.com/w/atom.xml"; }
      { url = "https://www.recurse.com/blog.rss"; }
      { url = "https://www.tedinski.com/feed.xml"; }
      { url = "https://www.tnhh.net/feed.xml"; }
      { url = "https://www.tweag.io/rss.xml"; }
      { url = "https://zwischenzugs.com/feed/"; }
    ];
  };
}
