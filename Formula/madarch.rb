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
  version "0.1.1"

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
  when "madarch-darwin-arm64" then "0a6045536ba350519e86b79638d9b9ce278ae76c6adb8b1ab27e087e19e806d9"
  when "madarch-darwin-x64" then "8f39b62f101312ea5aa122b361be9d89353434fd4acfbb9d7f4b57b251671318"
  when "madarch-linux-arm64" then "6533109d3c070256a5c29fe40a43a632782cbb4df845b0dfb070151092c28f7f"
  else "a84978c6785a1101976438007420bbc874ee8b6f3d4bd313d41756db731253ec"
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
