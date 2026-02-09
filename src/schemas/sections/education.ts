import z from "zod";
import { DateSchema } from "../helpers";

export const EducationItemSchema = z.object({
  institution: z.string().nonempty().nonoptional(),
  degree: z.string().nonempty().nonoptional(),
  grade: z.string().nonempty().optional(),
  "start-date": DateSchema.nonoptional(),
  "end-date": z
    .union([DateSchema.nonoptional(), z.literal("Present")])
    .nonoptional(),
  location: z.string().optional(),

  activities: z.array(z.string().nonempty()).optional(),
  description: z.string().optional(),
});

export const EducationSchema = z.array(EducationItemSchema);
