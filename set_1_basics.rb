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

  def plaintext_score
    # Simple score of common chars we'd expect in a string
    # assumes comparable strings are of equal length
    scores = self.chars.map do |char|
      case char
      when " "
        10
      when /[aeiou]/
        5
      when /[a-z]/, /[A-Z]/
        2
      when /[0-9]/
        2
      when %w(' " ! ? , . @ £ $ % ^ & *)
        1
      else
        -1
      end
    end

    scores.sum
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

    describe "#plaintext_score" do
      it "attempts a very simple check to see if a plaintext string is a sentence" do
        expect("Cooking MC's like a pound of bacon".plaintext_score).to eq(146)
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
    let(:source_a) { "1c0111001f010100061a024b53535009181c" }
    let(:source_b) { "686974207468652062756c6c277320657965" }
    let(:target) { "746865206b696420646f6e277420706c6179" }

    it "xor's source_a with source_b to match the target" do
      expect(source_a.convert_hexchars_to_bytes.zip(source_b.convert_hexchars_to_bytes).map {|a, b| a ^ b }.map { |x| x.to_s(16) }.join).to eq(target)
    end
  end

  describe "Challenge 3: Single-byte XOR cipher" do
    let(:cypher_text) {"1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"}

    it "finds the top matches" do
      key_score_plaintexts = (0..255).map do |i|
        plaintext = cypher_text.convert_hexchars_to_bytes.map { |byte| byte ^ i }.map(&:chr).join
        [i.chr, plaintext.plaintext_score, plaintext]
      end

      expect(key_score_plaintexts.sort{|a,b| a[1] <=> b[1]}.reverse[0..2]).to eq([
          ["X", 146, "Cooking MC's like a pound of bacon"],
          ["^", 74, "Eiimoha&KE!u&jomc&g&vishb&i`&dgeih"],
          ["R", 71, "Ieeacdm*GI-y*fcao*k*ze\x7Fdn*el*hkied"]
      ])
    end

    it "is X" do
      expect(cypher_text.convert_hexchars_to_bytes.map { |byte| byte ^ "X".ord }.map(&:chr).join).to eq("Cooking MC's like a pound of bacon")
    end
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
