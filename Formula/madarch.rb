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
  version "0.1.0"

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
  when "madarch-darwin-arm64" then "5170d46be7967c3bfc1b8a8e6aee5098df227b08d7af7a9c034e9734a6e38bdb"
  when "madarch-darwin-x64" then "998b1c8b625547228ad96b9d98173cd782177314dcb418abff14d11934a1bc09"
  when "madarch-linux-arm64" then "7896221a8d72f5aff796ddc374fe732bcd04c088a087ff4e2ff76612df7d8d39"
  else "9f084f23cb2fde1497b68b6f5cd1685f3977140a39461fb6a30302b8e76dd1a8"
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
    (bin / "madarch").write_exec_script libexec / "madarch-bin"
  end

  test do
    # The release build smoke runs new, opens the graph store and serves it;
    # this formula test confirms the installed executable answers as built.
    assert_equal "version: #{version}", pipe_output("#{bin}/madarch version 2>&1").strip
  end
end
