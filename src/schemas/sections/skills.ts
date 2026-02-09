import z from "zod";

export const SkillCategoryItemSchema = z.string().nonempty();

export const SkillCategorySchema = z.object({
  category: z.string().nonempty().nonoptional(),
  items: z.array(SkillCategoryItemSchema).min(1).nonoptional(),
});

export const SkillsSchema = z.array(SkillCategorySchema);
