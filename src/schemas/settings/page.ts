import z from "zod";
import { PaperSchema, FontSchema, MarginsSchema } from "../helpers";

export const PageSettingsSchema = z.object({
  paper: PaperSchema.optional(),
  font: FontSchema.optional(),
  margins: MarginsSchema.optional(),
});
