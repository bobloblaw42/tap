require "formula"

class Srelay < Formula
  homepage "http://socks-relay.sourceforge.net"
  url "https://downloads.sourceforge.net/project/socks-relay/socks-relay/srelay-0.4.8/srelay-0.4.8b6.tar.gz"
  sha256 "1203fbeacadb7cf1de1e1b915ac19f0100707868cc9d8997e1b75e08826ee9ab"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"

    system "make"

    bin.install "srelay"
    etc.install "srelay.conf"
    etc.install "srelay.passwd"
    man8.install "srelay.8"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/srelay</string>
          <string>-f</string>
          <string>-i</string>
          <string>lo0</string>
          <string>-c</string>
          <string>#{etc}/srelay.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/srelay.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/srelay.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system("#{bin}/srelay -v 2>&1 | grep ^srelay")
  end
end
