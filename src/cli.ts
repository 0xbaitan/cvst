#!/usr/bin/env -S npx tsx

import { $, argv, chalk } from "zx";
import { Zod2SchemaCommand } from "./commands/zod2schema";
import { HelpCommand } from "./commands/help";
import { Command } from "./types/command";

async function main() {
  let command: Command = new HelpCommand();
  if (argv._.includes("zod2schema")) {
    command = new Zod2SchemaCommand();
  }

  await command.execute(argv);
}

void main();
