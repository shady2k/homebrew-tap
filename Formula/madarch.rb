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
  version "0.2.4"

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
  when "madarch-darwin-arm64" then "9fa7edd272554e955a6582c0753ea1a58cb32ac483ae4db50ab0c2600616b39f"
  when "madarch-darwin-x64" then "528153f81086ee84aa811cb50ae83299bb8836272f98482b3ed806915115166a"
  when "madarch-linux-arm64" then "1852c699566e7caa44b401e8333f2c4dfd2e4b3def2f207923c65a09624a5490"
  else "0a8d7db34d6024ca2a83d7fefdaf8f1c1c081a3d8845f813e584acaaff23bb14"
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
