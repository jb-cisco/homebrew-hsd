class Hsd < Formula
  desc "hsd"
  version "1.2"

  on_arm do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.2/hsd-arm64"
    sha256 "54ac164c0d26234b53325241f00fcd64bd47a85a15cb3340af5c5e21d722e50b"
  end

  on_intel do
    url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.2/hsd-amd64"
    sha256 "951e44d6eee7cc7a62ac7212e70461348269ca0bb7e322784c8c723a7860bcc8"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. run hsd config init"
    end

    recommended = ["awscli", "kubernetes-cli", "helm"]
    missing = recommended.reject { |pkg| system("brew", "list", pkg, out: File::NULL, err: File::NULL) }
    unless missing.empty?
      puts "Recommended Homebrew packages missing: #{missing.join(', ')}"
      puts "You can install them with:"
      puts "  brew install #{missing.join(' ')}"
    end
  end
end