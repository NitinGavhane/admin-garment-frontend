# Admin App UI Generation Prompt

Use this prompt to generate the complete **DRISTI FASHIONS** Admin Panel UI screens with an AI image generator (Midjourney, DALL·E 3, Stable Diffusion / Flux, Leonardo AI, Recraft, etc.).

---

## Brand & Design System (Apply to ALL pages)

```
Brand: DRISTI FASHIONS — Premium Garment E-commerce
Logo: A circular brand emblem visible in the sidebar header and login card
Typography: Clean sans-serif font (Poppins / Inter), uppercase letter-spaced labels, bold numbers

Design Style:
- Premium, modern admin dashboard
- Card-based layouts with subtle borders and shadows
- Gradient accent lines and metallic surface treatments
- Glassmorphism or soft frosted elements for cards
- Responsive layout: left sidebar (280px) on desktop, hamburger drawer on mobile
- Dark/Light mode toggle in sidebar footer
- Royal violet + gold accent palette (or specify custom)
- Icons: outlined Material-style or Feather-style icons
- Status tags as small colored chips with dot indicators
- Buttons: metallic pill-shaped with gradient fill, uppercase text
- Search inputs with rounded corners and icon prefix
- Form sections in bordered card containers with section labels
- Toggle switches with colored active state
- Input fields with filled background and floating labels
- Scrollable content areas with consistent 16-24px padding
- Loading state: centered circular spinner with subtle glow
- Empty state: centered icon + message in a bordered card
```

---

## PAGE 1 — Login Screen

```
Full-screen centered layout with radial gradient background.
Content constrained to 420px max-width card.

Components:
- Brand logo (96px, rounded corners, gold border, violet glow shadow)
- "DRISTI FASHIONS" — 26px, bold, letter-spaced 4px, violet color
- "ADMIN PANEL" — 11px, wide letter-spacing 8px, gold color
- Login card (premium card, 28px padding, rounded 18px corners, gold-tinted border, layered shadows)
- Email input field with envelope icon prefix, filled lilac background
- Password input field with lock icon prefix, visibility toggle suffix
- Error alert box (red tinted, shown conditionally)
- "Sign In" button — full-width, metallic gold gradient, uppercase
- Footer: "SECURED ADMIN ACCESS" with gold hairline dividers

Layout (top to bottom):
  Logo → Brand Name → Admin subtitle → [spacing 56px] → Login Card → [spacing 28px] → Footer line
```

---

## PAGE 2 — Dashboard

```
Scrollable page with sticky header.

Header:
- "DASHBOARD" title (24px, bold, uppercase)
- "STORE OVERVIEW" subtitle with violet gradient accent line
- Refresh icon button (top right)
- Hamburger menu icon (mobile only)

Stat Cards Grid (responsive 2-4 columns):
- Total Users — people icon, violet gradient card, white text, large number
- Total Products — inventory icon, same card style
- Total Orders — receipt icon, same card style
- Revenue (₹) — trending up icon, same card style
- Pending Orders — schedule icon, same card style

Quick Actions Section:
- Section label with gradient line
- Action tiles in grid: "Add Product", "View Orders"
- Each tile: icon in gold metallic box, label in uppercase below

Pull-to-refresh enabled.

Loading: BrandLoader — circular gold spinner with violet glow halo + "LOADING" text
Empty: Not applicable (always shows stats)
```

---

## PAGE 3 — Products List

```
Column layout: Header + Search + Filter Chips + Scrollable List.

Header: "PRODUCTS" with count subtitle (e.g. "24 ITEMS")

Search Bar: Rounded input with search icon, gold accent on focus.

Gender Filter Chips: Horizontal row — All | Men | Women | Kids
  Active chip: gold gradient fill, dark text
  Inactive chip: light fill, border, muted text

Product Cards (each):
- 60px thumbnail image (in rounded container with gradient border)
- Title (bold, single line)
- SKU badge (small, rounded, filled background)
- Price: Discount price in coral/brand color (large, bold) | Original price (strikethrough, muted)
- Tags row: Featured (gold), Gender, Replace/Return, Active/Inactive, Category, Stock count
- Edit button (gold metallic icon button)
- Delete button (red gradient icon button)
- Card design: subtle gradient background, border-light, rounded 14px, shadow

FAB: "+" floating action button — gold metallic, bottom right

Pull-to-refresh. Empty state: inventory icon + "No products yet"
```

---

## PAGE 4 — Product Form

```
Scrolling form inside Column with sticky header.

Header: "NEW PRODUCT" or "EDIT PRODUCT"

Form Sections (each in bordered card with section label):

Section 1 — "BASIC INFO":
- Product Title (required)
- SKU (required)
- Price (required) + Discount Amount (side by side)
- Live price preview box (shows Original - Discount = Final with GST note)
- Stock input
- GST info box (info icon + explanation of CGST/SGST/IGST logic)

Section 2 — "IMAGES":
- Image URL input
- Image preview grid (90px thumbnails with "PRIMARY" badge, star to set primary, X to remove)
- "ADD IMAGE URL" button (outlined, gold)

Section 3 — "DETAILS":
- Description (multiline)
- Brand input
- Category dropdown (hierarchical: Parent → Subcategory items)
- Gender dropdown (Men/Women/Kids/Unisex)

Section 4 — "STATUS":
- Toggle switches row: Featured | Active
- Toggle switches row: Replaceable | Returnable

Section 5 — "VARIANTS":
- Repeated variant group: Size + Color (row 1), Stock + Price + Delete button (row 2)
- "ADD VARIANT" button (outlined, gold)

Save Button: Full-width metallic "Update Product" or "Create Product" button at bottom
```

---

## PAGE 5 — Orders List

```
Column layout: Header + Scrollable List.

Header: "ORDERS" with count subtitle (e.g. "42 TOTAL")

Order Cards (each):
- 48px receipt icon box (colored based on status)
- Order number (bold, e.g. #ORD-001)
- Final amount in coral/brand color
- Status tag (colored chip): Placed (blue) | Processing (amber) | Dispatched (purple) | Out for Delivery (teal) | Delivered (green) | Cancelled (red)
- Payment status tag: PAID (green) or UNPAID (amber)
- Chevron arrow right for detail navigation
- Card design: subtle gradient, rounded 14px, shadow

Pull-to-refresh. Empty: receipt icon + "No orders"
```

---

## PAGE 6 — Order Detail

```
Scrolling page with back button header.

Header: "ORDER" with order number subtitle

Order Info Card:
- Order number + Status tag
- Divider line
- Info blocks: Payment status | Subtotal (₹) | GST (₹) | Discount (₹, green if applied) | Total (₹, coral color)
- Shipping address (if available)

Items Section:
- Each item: product icon + name + quantity + line total price (in coral)
- Card design: subtle gradient, rounded 10px

Update Status Section:
- Section label
- Row of status chips: Placed | Processing | Dispatched | Out for Delivery | Delivered | Cancelled
- Current status: gold gradient filled
- Other statuses: light fill, clickable
```

---

## PAGE 7 — Users List

```
Column layout: Header + Search + Scrollable List.

Header: "USERS" with count subtitle (e.g. "156 REGISTERED")

Search Bar: Same style as Products search

User Cards (each):
- 48px avatar circle/rounded box:
  - First letter of name
  - Admin users get gold gradient background
  - Regular users get royal violet gradient background, white text
- Full name (bold)
- Email (muted, secondary)
- User ID badge (truncated, e.g. "P-A1B2C3")
- Tags row: Role (admin/user) | Verification status (Verified/Unverified) | Wallet balance (₹)
- Card design: subtle gradient, rounded 14px

Pull-to-refresh. Empty: people icon + "No users found"
```

---

## PAGE 8 — Categories List

```
Column layout: Header + Filter Chips + Scrollable List.

Header: "CATEGORIES" with count subtitle

Gender Filter Chips: All | Men | Women | Kids (same style as Products)

Category Cards (each):
- 46px thumbnail image or first-letter initial in colored circle
- Category name (bold)
- Info badge: "PARENT" or "SUBCATEGORY" + Gender + Subcategory count + Active status
- Subcategory cards are indented (20px left margin) with arrow icon prefix
- Edit button (gold metallic)
- Delete button (red gradient)
- Parent cards have coral-tinted border
- Card design: subtle gradient, rounded 14px

Grouped sections:
- Gender groups (Men / Women / Kids) with main category parents first
- "OTHER" section for unassigned
- "UNGROUPED" section for orphans

Pull-to-refresh. Empty: category icon + "No categories"
```

---

## PAGE 9 — Category Form

```
Scrolling form with sticky header.

Header: "NEW CATEGORY" or "EDIT CATEGORY"

Form Sections:

Section 1 — "CATEGORY INFO":
- Category Name (required)
- Description (multiline, optional)
- Image URL input with live preview (140px height, 16:9 or 3:2 ratio, close button overlay)
- Parent Category dropdown (includes "None (Top-level)" option)
- Gender dropdown (Men/Women/Kids/Unisex)
- Slug display (auto-generated, read-only on edit)
- Active toggle switch

Info Box (shown when no parent selected):
"No parent = top-level category. Subcategories can be assigned below it."
Gold info icon + text, gold-tinted border box

Save Button: Full-width metallic "Update Category" or "Create Category"
```

---

## PAGE 10 — Coupons List

```
Column layout: Header + Scrollable List.

Header: "COUPONS" with count subtitle (e.g. "8 ACTIVE")

Coupon Cards (each):
- 52px badge showing first 3 letters of code (violet gradient if active, gray if inactive)
- Coupon code (bold, uppercase, letter-spaced)
- Type + value badge: "PERCENTAGE · 10% OFF" or "FIXED · ₹50 OFF"
- Usage counter: "Used 15/100" + "· INACTIVE" if disabled
- Edit button (gold metallic)
- Delete button (red gradient)
- Card design: subtle gradient, rounded 14px

FAB: "+" button — gold metallic

Pull-to-refresh. Empty: gift icon + "No coupons"
```

---

## PAGE 11 — Coupon Form

```
Scrolling form with sticky header.

Header: "NEW COUPON" or "EDIT COUPON"

Form Sections:

Section 1 — "COUPON DETAILS":
- Coupon Code (required, auto-uppercased)
- Type dropdown: Percentage / Fixed
- Value (required, numeric, hint: "e.g. 10" or "e.g. 50")
- Min Order Amount + Max Discount (side by side, numeric)

Section 2 — "LIMITS":
- Expiry Date (text input, hint: ISO format)
- Usage Limit (numeric, default 100)
- Active toggle switch

Save Button: Full-width metallic "Update Coupon" or "Create Coupon"
```

---

## PAGE 12 — Sliding Banners List

```
Column layout: Header + Scrollable List.

Header: "SLIDING BANNERS" with count subtitle

Banner Cards (each — vertical layout with image on top):
- Banner image (3:2 aspect ratio, rounded top corners, cached network image)
- Title (bold) or "Untitled banner" fallback
- Info badge: "SECTION: hero · ORDER 1" + "· INACTIVE" if disabled
- Edit button (gold metallic)
- Delete button (red gradient)
- Card design: rounded 14px, image clipped to top

FAB: "+" button — gold metallic

Pull-to-refresh. Empty: carousel icon + "No banners yet — tap + to add one"
```

---

## PAGE 13 — Banner Form

```
Scrolling form with sticky header.

Header: "NEW BANNER" or "EDIT BANNER"

Form Sections:

Section 1 — "BANNER IMAGE":
- Image URL (required, hint: "recommended 1536×1024, 3:2")
- Live image preview (3:2 aspect ratio, close button overlay)

Section 2 — "DETAILS (OPTIONAL)":
- Title (shown for accessibility / overlays)
- Subtitle (optional)
- Link URL (where banner points)
- Link Text (e.g. "Shop Now")

Section 3 — "PLACEMENT":
- Section (text input, hint: "hero")
- Sort Order (numeric, hint: "0 = first")
- Active toggle switch

Save Button: Full-width metallic "Update Banner" or "Create Banner"
```

---

## SIDEBAR NAVIGATION (consistent across all pages)

```
Desktop (≥900px): Persistent left sidebar, 280px wide
Mobile (<900px): Hamburger menu opens Drawer overlay

Sidebar structure (top to bottom):

1. Brand Section (top, padded 24px):
   - Logo (56px, rounded, gold border, violet glow)
   - "DRISTI FASHIONS" (17px, bold)
   - Gold accent line + "ADMIN PANEL" (9px, gold, letter-spaced 4px)

2. Navigation Items (scrollable list):
   - Dashboard (grid dashboard icon)
   - Users (people icon)
   - Products (inventory/box icon)
   - Orders (receipt icon)
   - Categories (folder/category icon)
   - Banners (carousel/slideshow icon)
   - Coupons (gift card icon)
   - Active item: violet gradient pill with white icon + text
   - Inactive items: transparent, muted icon + text

3. Footer Section:
   - Dark/Light Mode toggle button (moon/sun icon)
   - Sign Out button (logout icon)
   Both buttons: gold metallic style, uppercase text
```

---

## COMPLETE PROMPT FOR IMAGE GENERATION

Copy-paste this for generating ALL screens at once:

```
Generate a complete premium admin dashboard UI for "DRISTI FASHIONS" — a garment e-commerce brand. The design must include ALL of the following pages as separate panels or a grid of screenshots. Brand logo visible in sidebar and login.

Design system: Clean sans-serif font, uppercase letter-spaced labels, card-based layouts with subtle gradients and shadows, metallic gold accent buttons, status tags as colored chips, outlined icons, rounded inputs with filled backgrounds, toggle switches with colored active states.

PAGES TO SHOW:
1. LOGIN — Centered card with logo, email/password fields, Sign In button, "SECURED ADMIN ACCESS" footer
2. DASHBOARD — Header with stat cards (Total Users, Products, Orders, Revenue, Pending Orders) + Quick Actions grid
3. PRODUCTS LIST — Search bar, gender chips (All/Men/Women/Kids), product cards with thumbnail, SKU, price, stock, tags, edit/delete buttons, FAB
4. PRODUCT FORM — Sections: Basic Info (title, SKU, price, discount, stock, GST info), Images (URL input + grid), Details (description, brand, category, gender dropdowns), Status toggles (Featured/Active/Replace/Return), Variants (size/color/stock/price rows)
5. ORDERS LIST — Order cards with number, amount, status chip (color-coded: Placed/Processing/Dispatched/Out for Delivery/Delivered/Cancelled), payment status
6. ORDER DETAIL — Order info (payment, subtotal, GST, discount, total, address), items list, status update buttons row
7. USERS LIST — User cards with avatar initial, name, email, ID, role tag, verified status, wallet balance
8. CATEGORIES LIST — Gender chips, parent/subcategory hierarchy, category cards with image/initial, type badge, edit/delete
9. CATEGORY FORM — Name, description, image URL with preview, parent dropdown, gender dropdown, active toggle
10. COUPONS LIST — Coupon cards with code badge, type/value, usage count, edit/delete, FAB
11. COUPON FORM — Code, type dropdown, value, min order, max discount, expiry, usage limit, active toggle
12. BANNERS LIST — Banner cards with 3:2 image preview, title, section, sort order, active status, edit/delete, FAB
13. BANNER FORM — Image URL with 3:2 preview, title, subtitle, link URL, link text, section, sort order, active toggle

SIDEBAR (on every page): 280px left sidebar with logo + brand name + "ADMIN PANEL" at top, navigation items (Dashboard, Users, Products, Orders, Categories, Banners, Coupons) with active state highlighted, Dark/Light mode toggle and Sign Out at bottom.

Color palette: Violet/lavender primary (#8B5CF6), gold secondary accents (#7C3AED), white/surface cards, soft lilac backgrounds (#F3F0FC), royal violet gradients for stat cards, coral (#E11D48) for errors/delete, green (#16A34A) for success/delivered. Dark mode variant with deep indigo backgrounds (#17132A).

Style: Premium, modern, clean, high-end fashion admin panel. Not generic Bootstrap.
```
