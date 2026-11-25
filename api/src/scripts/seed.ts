import bcrypt from 'bcryptjs';
import { connectDatabase, disconnectDatabase } from '../config/database.js';
import { User } from '../modules/auth/auth.model.js';
import { Category } from '../modules/categories/category.model.js';
import { ArtisanProfile } from '../modules/artisans/artisan.model.js';
import { ServiceRequest } from '../modules/requests/request.model.js';
import { Quote } from '../modules/quotes/quote.model.js';
import { Review } from '../modules/reviews/review.model.js';

async function seed() {
  await connectDatabase();
  console.log('🌱 Seeding database...');

  // Clear existing collections
  await Promise.all([
    User.deleteMany({}),
    Category.deleteMany({}),
    ArtisanProfile.deleteMany({}),
    ServiceRequest.deleteMany({}),
    Quote.deleteMany({}),
    Review.deleteMany({}),
  ]);

  const salt = await bcrypt.genSalt(10);
  const commonPassword = await bcrypt.hash('Password123!', salt);

  // 1. Categories
  const categories = await Category.create([
    { name: 'Plomberie', slug: 'plomberie', icon: 'plumbing', description: 'Installation, fuites, dépannage sanitaire' },
    { name: 'Électricité', slug: 'electricite', icon: 'electrical_services', description: 'Câblage, pannes, éclairage, tableaux' },
    { name: 'Menuiserie', slug: 'menuiserie', icon: 'carpenter', description: 'Meubles sur mesure, portes, fenêtres' },
    { name: 'Maçonnerie', slug: 'maconnerie', icon: 'foundation', description: 'Gros œuvre, rénovation, crépis, clôtures' },
    { name: 'Peinture', slug: 'peinture', icon: 'format_paint', description: 'Peinture intérieure, extérieure, décoration' },
    { name: 'Mécanique', slug: 'mecanique', icon: 'build', description: 'Réparation moto, voiture, entretien moteur' },
  ]);

  // 2. Users
  const admin = await User.create({
    email: 'admin@fasoskills.bf',
    phone: '+22670000001',
    fullName: 'Administrateur Principal',
    passwordHash: commonPassword,
    role: 'admin',
    isVerified: true,
  });

  const client1 = await User.create({
    email: 'client1@fasoskills.bf',
    phone: '+22670111111',
    fullName: 'Aminata Ouédraogo',
    passwordHash: commonPassword,
    role: 'client',
    isVerified: true,
  });

  const client2 = await User.create({
    email: 'client2@fasoskills.bf',
    phone: '+22670222222',
    fullName: 'Ibrahim Sawadogo',
    passwordHash: commonPassword,
    role: 'client',
    isVerified: true,
  });

  const artisanUser1 = await User.create({
    email: 'artisan1@fasoskills.bf',
    phone: '+22670333333',
    fullName: 'Moussa Kaboré',
    passwordHash: commonPassword,
    role: 'artisan',
    isVerified: true,
  });

  const artisanUser2 = await User.create({
    email: 'artisan2@fasoskills.bf',
    phone: '+22670444444',
    fullName: 'Seydou Traoré',
    passwordHash: commonPassword,
    role: 'artisan',
    isVerified: true,
  });

  // 3. Artisan Profiles
  const profile1 = await ArtisanProfile.create({
    userId: artisanUser1._id,
    category: categories[0]._id, // Plomberie
    specialty: 'Plombier Sanitaire & Chauffe-eau',
    city: 'Ouagadougou',
    experienceYears: 7,
    bio: 'Artisan qualifié avec 7 ans d’expérience en dépannage et rénovation.',
    availability: 'Disponible 7j/7',
    rating: 4.8,
    reviewsCount: 12,
    completedJobs: 15,
    isVerified: true,
    profileStatus: 'complete',
  });

  const profile2 = await ArtisanProfile.create({
    userId: artisanUser2._id,
    category: categories[1]._id, // Electricite
    specialty: 'Électricien Bâtiment & Solaire',
    city: 'Bobo-Dioulasso',
    experienceYears: 5,
    bio: 'Installation solaire et dépannage électrique rapide.',
    availability: 'Disponible',
    rating: 4.6,
    reviewsCount: 8,
    completedJobs: 10,
    isVerified: true,
    profileStatus: 'complete',
  });

  // 4. Service Requests
  const request1 = await ServiceRequest.create({
    clientId: client1._id,
    categoryId: categories[0]._id,
    title: 'Fuite d’eau importante sous évier de cuisine',
    description: 'Une fuite permanente sous l’évier inonde la cuisine. Besoin d’intervention rapide.',
    city: 'Ouagadougou',
    address: 'Karpala, Rue 14',
    status: 'pending',
  });

  const request2 = await ServiceRequest.create({
    clientId: client2._id,
    categoryId: categories[1]._id,
    title: 'Installation de panneau solaire et onduleur',
    description: 'Installation complète d’un kit solaire 3kVA avec batteries de secours.',
    city: 'Bobo-Dioulasso',
    address: 'Secteur 22',
    status: 'completed',
  });

  // 5. Quotes
  const quote1 = await Quote.create({
    requestId: request1._id,
    artisanId: profile1._id,
    amount: 15000,
    estimatedDays: 1,
    message: 'Je peux intervenir dès ce soir avec les pièces de rechange.',
    status: 'pending',
  });

  const quote2 = await Quote.create({
    requestId: request2._id,
    artisanId: profile2._id,
    amount: 125000,
    estimatedDays: 2,
    message: 'Devis incluant main-d’œuvre et câblage de sécurité.',
    status: 'accepted',
  });

  request2.acceptedQuoteId = quote2._id as any;
  await request2.save();

  // 6. Review
  await Review.create({
    requestId: request2._id,
    clientId: client2._id,
    artisanId: profile2._id,
    rating: 5,
    comment: 'Excellent travail, ponctuel et très professionnel !',
  });

  console.log('✅ Database seeded successfully!');
  console.log('Test Accounts (Password: Password123!):');
  console.log('- Admin: admin@fasoskills.bf');
  console.log('- Client: client1@fasoskills.bf');
  console.log('- Artisan: artisan1@fasoskills.bf');

  await disconnectDatabase();
}

seed().catch((err) => {
  console.error('Seeding failed:', err);
  process.exit(1);
});
