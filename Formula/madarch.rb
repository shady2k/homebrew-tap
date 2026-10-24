# The Homebrew formula of the madarch release binary (madarch-lfhu).
#
# Install from the maintained tap:
#
#   brew install shady2k/tap/madarch
#
# (or install straight from any tap that carries this file). The formula
# installs the release binary only: no build steps, no dependencies; the
# wiki app rides inside the binary, and every release carries the SHA256
# sums the formula checks.
class Madarch < Formula
  desc "The madarch command as one release binary: products, wiki, upgrade"
  homepage "https://github.com/shady2k/madarch"
  version "0.2.3"

  artifact = if OS.mac? && Hardware::CPU.arm?
    "madarch-darwin-arm64"
  elsif OS.mac?
    "madarch-darwin-x64"
  elsif Hardware::CPU.arm?
    "madarch-linux-arm64"
  else
    "madarch-linux-x64"
  end
  url "https://github.com/shady2k/madarch/releases/download/v#{version}/#{artifact}"
  checksum = case artifact
  when "madarch-darwin-arm64" then "dd2f36eaa7f33ce59cb54f44bb939acda266a35a54151955ce674f2f12c84e6f"
  when "madarch-darwin-x64" then "b99752f9069d3b7e60bdb5e83e171d33aab05868d46ff80d27f04903ebdf9397"
  when "madarch-linux-arm64" then "40d073f5f1aac3dd51d0a789f0af5deed65daaf0f501c635eed0773ba1ed97e6"
  else "4b6f2d756e03edf3939723dbf0f79f62decd5b1e9395ece32645ab54b92c9e21"
  end
  sha256 checksum

  # The binary is self-contained and needs no system OpenSSL.

  def install
    artifact = if OS.mac? && Hardware::CPU.arm?
      "madarch-darwin-arm64"
    elsif OS.mac?
      "madarch-darwin-x64"
    elsif Hardware::CPU.arm?
      "madarch-linux-arm64"
    else
      "madarch-linux-x64"
    end
    libexec.install artifact => "madarch-bin"
    (libexec / "madarch-bin").chmod 0755
    bin.install_symlink libexec / "madarch-bin" => "madarch"
  end

  test do
    # The release build smoke runs new, opens the graph store and serves it;
    # this formula test confirms the installed executable answers as built.
    assert_equal "version: #{version}", pipe_output("#{bin}/madarch version 2>&1").strip
  end
end
