import z from "zod";
import { FontSchema, MarginSchema } from "../helpers";

export const SectionSettingsSchema = z.object({
  spacings: z
    .object({
      above: MarginSchema.optional(),
      below: MarginSchema.optional(),
    })
    .optional(),

  headings: z
    .object({
      font: FontSchema.optional(),
      color: z.string().optional(),
      case: z
        .enum(["uppercase", "lowercase", "capitalize", "normal"])
        .optional(),
      bold: z.boolean().optional(),
    })
    .optional(),
});
