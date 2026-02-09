import { Arguments } from "./arguments";

export interface Command {
  readonly name: string;
  readonly description: string;
  execute: (args: Arguments) => Promise<void> | void;
}
