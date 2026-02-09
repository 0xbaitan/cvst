import { argv, chalk } from "zx";
import { Command } from "../types/command";
import { Helpable } from "../types/helpable";
import { Arguments } from "../types/arguments";

export class HelpCommand implements Command, Helpable {
  public readonly name: string;
  public readonly description: string;

  constructor() {
    this.name = "help";
    this.description = "Show help information";
  }

  async execute(args: Arguments): Promise<void> {
    return this.printHelp();
  }

  async printHelp(): Promise<void> {
    console.log(chalk.white`
Usage: cvst [options] <command>

Options:
  -h, --help          Show help information
  -v, --version       Show version number

Commands:
  init                Initialize a new CVST project
  zod2schema          Generate YAML/JSON schema from Zod schema
  generate            Generate resume from a YAML/JSON file
  serve               Start a local server to preview the resume
  export              Export the resume to PDF or other formats
  validate            Validate the resume schema
`);
  }
}
