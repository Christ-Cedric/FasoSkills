import { Category } from './category.model.js';
import { NotFoundError, ConflictError } from '../../core/errors/app-error.js';

export class CategoryService {
  private slugify(text: string): string {
    return text
      .toLowerCase()
      .replace(/[^\w ]+/g, '')
      .replace(/ +/g, '-');
  }

  public async list() {
    return Category.find({ isActive: true }).sort({ name: 1 });
  }

  public async getById(id: string) {
    const category = await Category.findById(id);
    if (!category) throw new NotFoundError('Category');
    return category;
  }

  public async create(data: { name: string; icon?: string; description?: string }) {
    const slug = this.slugify(data.name);
    const existing = await Category.findOne({ slug });
    if (existing) throw new ConflictError('Category with this name already exists');

    return Category.create({ ...data, slug });
  }
}

export const categoryService = new CategoryService();
