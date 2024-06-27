require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'base64'
  gem 'json'
  gem 'rspec'
end

class String

  def hexchars
    self.chars.each_slice(2).map(&:join)
  end

  def convert_hexchars_to_bytes
    self.hexchars.map(&:hex)
  end

  def convert_hexchars_to_chars
    self.convert_hexchars_to_bytes.map(&:chr)
  end
end

RSpec.describe "Crypto Challenges Set 1" do

  describe "String extensions" do
    describe "#hexchars" do
      it "slices self into hex bytes" do
        expect("59656c6c6f77205375626d6172696e65".hexchars).to eq(["59", "65", "6c", "6c", "6f", "77", "20", "53", "75", "62", "6d", "61", "72", "69", "6e", "65"])
      end
    end

    describe "#convert_hexchars_to_bytes" do
      it "converts a hex string into a byte array" do
        expect("59656c6c6f77205375626d6172696e65".convert_hexchars_to_bytes).to eq( [89, 101, 108, 108, 111, 119, 32, 83, 117, 98, 109, 97, 114, 105, 110, 101])
      end
    end

    describe "#convert_hexchars_to_chars" do
      it "converts a hex string to chars" do
        expect("59656c6c6f77205375626d6172696e65".convert_hexchars_to_chars.join).to eq("Yellow Submarine")
      end
    end
  end

  describe "Challenge 1: Convert hex to base64" do
    let(:source) { "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d" }
    let(:target) { "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t" }

    it "converts the source hex string into the base64 encoded target string" do
      expect(Base64.strict_encode64(source.convert_hexchars_to_chars.join)).to eq(target)
    end
  end

  describe "Challenge 2: Fixed XOR" do
  end

  describe "Challenge 3: Single-byte XOR cipher" do
  end

  describe "Challenge 4: Detect single-character XOR" do
  end

  describe "Challenge 5: Implement repeating-key XOR" do
  end

  describe "Challenge 6: Break repeating-key XOR" do
  end

  describe "Challenge 7: AES in ECB mode" do
  end

  describe "Challenge 8: Detect AES in ECB mode" do
  end
end
