import { chalk } from "zx";
import { Arguments } from "../types/arguments";
import { Helpable } from "../types/helpable";
import { Command } from "../types/command";
import * as fs from "fs";
import * as path from "path";
import z, { ZodType } from "zod";
import { zodToJsonSchema } from "zod-to-json-schema";

export class Zod2SchemaCommand implements Command, Helpable {
  public readonly name: string;
  public readonly description: string;

  constructor() {
    this.name = "zod2schema";
    this.description = "Generate YAML/JSON schema from Zod schema";
  }

  async printHelp(): Promise<void> {
    console.log(chalk`
    cvst ${this.name} [options]

    Description:
      ${this.description}

    Options:
      --input, -i     Path to the input Zod schema file (required)
      --output, -o    Path to the output schema file (JSON) (required)
      --help, -h      Show help information
    `);
  }

  isZodSchema(obj: any): obj is ZodType<any> {
    return (
      obj instanceof ZodType ||
      (typeof obj?.parse === "function" &&
        typeof obj?._def?.typeName === "string" &&
        obj._def.typeName.startsWith("Zod"))
    );
  }

  async ensureInputFileExists(filePath: string): Promise<void> {
    if (!filePath || typeof filePath !== "string" || filePath.trim() === "") {
      throw new Error(`Input file path is required.`);
    }

    if (filePath.match(/[\*\?"<>\|]/)) {
      throw new Error(
        `Input file path contains invalid characters: * ? " < > |`,
      );
    }

    if (!filePath.match(/\.(ts|js|tsx|jsx)$/i)) {
      throw new Error(
        `Input file must have a .ts, .js, .tsx, or .jsx extension.`,
      );
    }

    return fs.promises.access(filePath, fs.constants.F_OK | fs.constants.R_OK);
  }

  async ensureOutputFileExists(filePath: string): Promise<void> {
    if (!filePath || typeof filePath !== "string" || filePath.trim() === "") {
      throw new Error(`Output file path is required.`);
    }

    if (filePath.match(/[\*\?"<>\|]/)) {
      throw new Error(
        `Output file path contains invalid characters: * ? " < > |`,
      );
    }

    if (!filePath.match(/\.json$/i)) {
      throw new Error(`Output file must have a .json extension.`);
    }

    await fs.promises.access(filePath, fs.constants.F_OK).catch(async () => {
      await fs.promises.mkdir(path.dirname(filePath), { recursive: true });
      await fs.promises.writeFile(filePath, JSON.stringify({}, null, 2), {
        encoding: "utf-8",
      });
    });

    await fs.promises
      .access(filePath, fs.constants.R_OK | fs.constants.W_OK)
      .catch(
        async () =>
          await fs.promises.chmod(
            filePath,
            fs.constants.W_OK | fs.constants.R_OK,
          ),
      );
  }

  async execute(args: Arguments): Promise<void> {
    if (args.help) {
      this.printHelp();
      return;
    }
    const input = args.input || args.i || undefined;
    const output = args.output || args.o || undefined;

    if (!input || !output) {
      console.error(
        chalk.red("Error: Both input and output file paths are required."),
      );
      this.printHelp();
      return;
    }

    await this.ensureInputFileExists(input);
    await this.ensureOutputFileExists(output);

    try {
      const schema = await import(fs.realpathSync(input)).then(
        (mod) => mod.default || mod,
      );

      if (!this.isZodSchema(schema)) {
        throw new Error(
          "The provided input file does not export a valid Zod schema.",
        );
      }

      const jsonSchema = schema.toJSONSchema({
        target: "draft-07",
        io: "output",
        unrepresentable: "throw",
      });

      await fs.promises.writeFile(output, JSON.stringify(jsonSchema, null, 2), {
        encoding: "utf-8",
      });

      console.log(
        chalk.green(`Successfully generated JSON schema at: ${output}`),
      );
    } catch (error: any) {
      console.error(chalk.red(`Error: ${error.message}`));
    }
  }
}
