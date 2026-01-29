/**
 * QuickAdd Macro: random_readable_name
 * Creates a new note in the "Assorted Notes/" folder with a random name
 * in the format: adjective-noun (or multiple-adjective-noun if needed)
 *
 * Automatically finds a unique name by generating new combinations.
 * If all combinations are taken, adds additional adjectives.
 */
module.exports = async (params) => {
  const { app } = params;

  const adjectives = [
    "awesome", "cool", "quick", "happy", "sleepy", "silly",
    "fuzzy", "golden", "magic", "sparkle", "brave", "silent",
    "epic", "wondrous", "calm", "vivid", "lucky", "mighty", "gentle", "bold",
    "bright", "cheerful", "daring", "eager", "fierce", "graceful",
    "jolly", "kind", "lively", "merry", "noble", "plucky", "quick-witted",
    "radiant", "swift", "valiant", "zesty", "charming", "creative",
    "delightful", "dynamic", "elegant", "fearless", "glorious", "harmonious",
    "imaginative", "jovial", "passionate", "resilient", "tranquil",
    "ancient", "azure", "blazing", "celestial", "cosmic", "crimson",
    "crystal", "curious", "dazzling", "divine", "dreamy", "electric",
    "emerald", "enchanted", "eternal", "flaming", "frosty", "gleaming",
    "glowing", "grand", "hidden", "icy", "infinite", "jade",
    "luminous", "lunar", "majestic", "marble", "misty", "mystic",
    "obsidian", "peaceful", "platinum", "pristine", "quantum", "rapid",
    "royal", "ruby", "sacred", "sapphire", "serene", "shimmering",
    "silver", "soaring", "solar", "sparkling", "stellar", "stunning",
    "supreme", "thunderous", "timeless", "titan", "turquoise", "twilight",
    "ultimate", "velvet", "vibrant", "violet", "wandering", "whispering",
    "wild", "wise", "witty", "zealous", "amber", "arctic",
    "astral", "autumn", "blissful", "breezy", "brilliant", "bronze",
    "bubbly", "charmed", "classic", "clever", "cobalt", "cozy",
    "dapper", "dashing", "distant", "dusty", "fancy", "floating",
    "flowing", "fluffy", "fresh", "friendly", "frosted", "gentle",
    "ghostly", "giggling", "gleeful", "golden", "gorgeous", "grateful",
    "groovy", "haunted", "heavenly", "hollow", "honest", "humble",
    "hungry", "inspired", "instant", "joyful", "lasting", "laughing",
    "lavender", "legendary", "lonely", "loud", "loving", "medieval",
    "melodic", "mighty", "modest", "moonlit", "mysterious", "neon",
    "nimble", "opulent", "patient", "perfect", "playful", "poetic",
    "polished", "powerful", "proud", "pure", "random", "rare",
    "restless", "roaming", "robust", "rugged", "rustic", "scarlet",
    "shadowy", "shining", "singing", "sleek", "smooth", "snowy",
    "soft", "solid", "soothing", "spring", "starry", "steady",
    "steaming", "stormy", "strong", "subtle", "summer", "sunny",
    "twinkling", "vibrating", "vintage", "warm", "wavy", "wealthy",
    "weary", "western", "whirling", "wholesome", "wicked", "windy",
    "winter", "wooden", "youthful"
  ];

  const nouns = [
    "cat", "aardvark", "bear", "dragon", "cloud", "star",
    "river", "mountain", "planet", "whisper", "tree", "journey",
    "secret", "shadow", "vortex", "cookie", "puzzle", "treasure", "unicorn", "wizard",
    "phoenix", "galaxy", "ocean", "forest", "island", "comet",
    "dolphin", "eclipse", "firefly", "horizon", "jungle", "labyrinth", "miracle",
    "nebula", "paradise", "quasar", "rainbow", "symphony", "castle", "owl",
    "pearl", "ember", "canyon", "meadow", "blossom", "voyage",
    "beacon", "serenity", "glacier", "harbor",
    "anchor", "angel", "apex", "arrow", "aurora", "avalanche",
    "badger", "bandit", "bastion", "bat", "beam", "beast",
    "beetle", "bell", "birch", "blade", "blaze", "bloom",
    "boar", "bolt", "book", "boulder", "breeze", "bridge",
    "brook", "bumblebee", "butterfly", "cabin", "cactus", "cape",
    "cardinal", "cascade", "cave", "cedar", "chalice", "chamber",
    "cheetah", "citadel", "cliff", "cobra", "compass", "condor",
    "coral", "cosmos", "cove", "crane", "crater", "creature",
    "creek", "crest", "cricket", "crow", "crown", "crystal",
    "cyclone", "cypress", "dagger", "dandelion", "dawn", "deer",
    "delta", "den", "desert", "diamond", "dingo", "dove",
    "dragonfly", "dream", "dune", "eagle", "earth", "echo",
    "edge", "elk", "elm", "equinox", "essence", "falcon",
    "fang", "fawn", "feather", "fern", "field", "finch",
    "fjord", "flame", "flash", "flint", "flood", "flower",
    "foam", "fog", "fortress", "fountain", "fox", "frost",
    "furnace", "gale", "garden", "garnet", "gate", "gazelle",
    "gecko", "gem", "giant", "giraffe", "glen", "globe",
    "goat", "goblin", "gorge", "griffin", "grove", "guardian",
    "guide", "gull", "hammer", "hare", "harmony", "harvest",
    "hawk", "haven", "hazel", "helix", "heron", "hill",
    "hive", "hollow", "horn", "horse", "hound", "hurricane",
    "hydra", "ibex", "ibis", "iguana", "impulse", "iris",
    "iron", "ivy", "jackal", "jade", "jaguar", "javelin",
    "jay", "jewel", "kestrel", "key", "kingfisher", "kite",
    "knight", "koala", "kraken", "lagoon", "lake", "lance",
    "lantern", "lark", "lava", "leaf", "legend", "lemur",
    "leopard", "light", "lighthouse", "lightning", "lily", "lion",
    "lizard", "llama", "locket", "locust", "lodge", "lotus",
    "lynx", "lyric", "magma", "mammoth", "mane", "mantle",
    "maple", "marble", "mare", "marsh", "meadowlark", "melody",
    "mesa", "meteor", "mink", "mirage", "mist", "monarch",
    "mongoose", "monk", "moon", "moose", "moss", "moth",
    "muse", "narwhal", "nest", "nettle", "newt", "nightingale",
    "nomad", "north", "nova", "oak", "oasis", "obsidian",
    "orca", "orchid", "ore", "oriole", "osprey", "otter",
    "outpost", "palm", "panther", "parrot", "passage", "path",
    "pavilion", "pebble", "pelican", "petal", "pike", "pilgrim",
    "pine", "pinnacle", "plain", "poem", "portal", "prairie",
    "prism", "puma", "python", "quarry", "quest", "rabbit",
    "raccoon", "radiance", "rain", "raven", "ray", "reef",
    "refuge", "relic", "ridge", "rift", "ripple", "rogue",
    "root", "rose", "ruby", "ruin", "runner", "rush",
    "saber", "sage", "sail", "salamander", "salmon", "sanctuary",
    "sand", "sapphire", "savanna", "scarab", "scholar", "scorpion",
    "scout", "scroll", "seal", "seashell", "seed", "sentinel",
    "serpent", "shade", "shard", "shark", "shell", "shield",
    "shore", "shrine", "signal", "silk", "silver", "skylark",
    "slate", "snow", "song", "soul", "south", "spark",
    "sparrow", "spear", "specter", "spider", "spine", "spirit",
    "spire", "spring", "sprout", "squirrel", "stag", "starling",
    "steel", "stone", "storm", "stream", "summit", "sun",
    "sunrise", "sunset", "surge", "swallow", "swan", "swift",
    "sword", "tablet", "talon", "tempest", "temple", "terrace",
    "thorn", "thrush", "thunder", "tide", "tiger", "timber",
    "titan", "toad", "topaz", "torch", "tortoise", "totem",
    "tower", "trail", "trident", "tundra", "tunnel", "turtle",
    "twig", "typhoon", "valley", "vapor", "vault", "veil",
    "vine", "viper", "vision", "volcano", "vulture", "warden",
    "warrior", "wasp", "water", "wave", "weasel", "west",
    "whale", "whirlwind", "willow", "wind", "wing", "winter",
    "wolf", "wolverine", "wombat", "wood", "wren", "wyrm",
    "yak", "zenith", "zephyr"
  ];

  const folderPath = "Assorted Notes";

  // Function to get a random item from an array
  const getRandomItem = (arr) => arr[Math.floor(Math.random() * arr.length)];

  // Function to generate a random name with specified number of adjectives
  const generateName = (adjectiveCount = 1) => {
    const selectedAdjectives = [];
    for (let i = 0; i < adjectiveCount; i++) {
      selectedAdjectives.push(getRandomItem(adjectives));
    }
    const noun = getRandomItem(nouns);
    return [...selectedAdjectives, noun].join("-");
  };

  // Function to check if a file exists
  const fileExists = (filename) => {
    const filePath = `${folderPath}/${filename}.md`;
    return app.vault.getAbstractFileByPath(filePath) !== null;
  };

  // Find a unique filename
  let filename;
  let adjectiveCount = 1;
  let attempts = 0;
  const maxAttemptsPerLevel = adjectives.length * nouns.length;

  while (true) {
    filename = generateName(adjectiveCount);

    if (!fileExists(filename)) {
      break;
    }

    attempts++;

    // If we've tried many times at this level, add another adjective
    if (attempts >= maxAttemptsPerLevel) {
      adjectiveCount++;
      attempts = 0;
    }
  }

  // Create the new note
  const filePath = `${folderPath}/${filename}.md`;
  await app.vault.create(filePath, "");

  // Open the new note
  const file = app.vault.getAbstractFileByPath(filePath);
  if (file) {
    const leaf = app.workspace.getLeaf(false);
    await leaf.openFile(file);
  }
};
