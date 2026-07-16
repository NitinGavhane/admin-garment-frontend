# Admin Panel — Multi-Theme Generation Prompt

Use this prompt with an AI image generator (Midjourney, DALL·E, Stable Diffusion, etc.) to generate theme previews for the **DRISTI FASHIONS** admin panel.

---

## Brand Identity

- **Brand Name:** DRISTI FASHIONS
- **Brand Type:** Garment / Apparel E-commerce
- **Logo:** `assets/logo.jpg` — The logo should appear in the sidebar/nav header and login screen prominently
- **Current Style Reference:** Premium gold-plate UI components, soft lavender/violet canvas, royal metallic gradients, Poppins font
- **App Name:** ADMIN PANEL (subtitle under brand)

---

## Admin Pages to Generate Themes For

Generate a cohesive theme pack (all pages below should share the SAME theme color palette per image set). For EACH theme concept, generate ONE image showing EACH of these pages:

### 1. Login Page
- Centered card with brand logo, "DRISTI FASHIONS" heading, "ADMIN PANEL" subtitle
- Email & password fields with icons
- "Sign In" button
- "SECURED ADMIN ACCESS" footer

### 2. Dashboard Page
- Header: "DASHBOARD" / "STORE OVERVIEW"
- Stat cards: Total Users, Total Products, Total Orders, Revenue (₹), Pending Orders
- Quick Actions grid: Add Product, View Orders
- Each card shows icon + value + label

### 3. Products List Page
- Header: "PRODUCTS" with count
- Search bar + gender filter chips (All, Men, Women, Kids)
- Product cards showing: thumbnail image, title, SKU, price (with discount), stock, tags (Featured, gender, Replace/Return, Active/Inactive, category)
- Edit & Delete action buttons per card
- FAB (+ button) for adding new product

### 4. Product Form Page
- Header: "NEW PRODUCT" or "EDIT PRODUCT"
- Sections: Basic Info (title, SKU, price, discount amount, stock), GST info box
- Images section (image URL input, preview grid with primary tag)
- Details section (description, brand, category dropdown, gender dropdown)
- Status section (Featured, Active, Replace, Return toggles)
- Variants section (size, color, stock, price per variant)
- Save button

### 5. Orders List Page
- Header: "ORDERS" with count
- Order cards: order number, final amount, status tags (placed/processing/dispatched/out_for_delivery/delivered/cancelled), payment status
- Chevron for detail navigation

### 6. Order Detail Page
- Order number header, status badge
- Info blocks: Payment, Subtotal, GST, Discount, Total, Shipping Address
- Items list with product name, qty, price
- "Update Status" buttons for each order status

### 7. Users List Page
- Header: "USERS" with count
- Search bar
- User cards: avatar initial, full name, email, user ID, role tag, verification status, wallet balance (₹)

### 8. Categories List Page
- Header: "CATEGORIES" with count
- Gender filter chips (All, Men, Women, Kids)
- Parent/subcategory hierarchy display
- Category cards: image/initial, name, type (PARENT/SUBCATEGORY), gender, subcategory count, active status
- Edit & Delete action buttons per card

### 9. Category Form Page
- Header: "NEW CATEGORY" or "EDIT CATEGORY"
- Fields: Category Name, Description, Image URL (with preview), Parent Category dropdown, Gender dropdown
- Active toggle
- Info box about top-level vs subcategory

### 10. Coupons List Page
- Header: "COUPONS" with count
- Coupon cards: code initials badge, full code, type (percentage/fixed), value off, usage count/limit, active/inactive
- Edit & Delete action buttons

### 11. Coupon Form Page
- Header: "NEW COUPON" or "EDIT COUPON"
- Fields: Coupon Code, Type dropdown (Percentage/Fixed), Value, Min Order, Max Discount
- Limits section: Expiry Date, Usage Limit, Active toggle

### 12. Sliding Banners List Page
- Header: "SLIDING BANNERS" with count
- Banner cards: image preview (3:2 aspect ratio), title, section name, sort order, active status
- Edit & Delete action buttons

### 13. Banner Form Page
- Header: "NEW BANNER" or "EDIT BANNER"
- Fields: Image URL (with 3:2 preview), Title, Subtitle, Link URL, Link Text
- Placement: Section name, Sort Order, Active toggle

---

## Sidebar Navigation (on all pages)
- Logo + brand name + "ADMIN PANEL" at top
- Nav items: Dashboard, Users, Products, Orders, Categories, Banners, Coupons
- Dark/Light mode toggle at bottom
- Sign Out button at bottom
- On desktop: persistent sidebar 280px wide
- On mobile: hamburger menu → drawer

---

## Theme Prompt Template

Use this structure for EACH theme concept:

```
DRISTI FASHIONS ADMIN PANEL — [THEME NAME]

A premium apparel e-commerce admin dashboard UI.
[Color palette description]
[Design style description]

Show all 13 pages listed above with the DRISTI FASHIONS logo visible.
All pages must share ONE consistent color palette.
Premium, modern, clean UI with card-based layouts.
Typography: clean sans-serif, letter-spaced uppercase labels.
```

### Suggested Theme Concepts:
1. **Royal Violet** (current) — Deep violet, lavender canvas, gold accents
2. **Obsidian Black** — Dark charcoal, emerald green accents, white typography
3. **Sapphire Blue** — Navy base, sapphire gradients, silver accents
4. **Rose Gold** — Blush pink, rose gold metallic, cream surfaces
5. **Midnight Teal** — Deep teal, dark indigo, copper accents
6. **Crimson Amber** — Rich burgundy, warm amber gold, ivory
7. **Forest Emerald** — Dark forest green, emerald gradients, brass accents
8. **Pearl Gray** — Warm gray, pearl white, champagne gold
9. **Plum Wine** — Deep plum, wine red, soft mauve
10. **Nordic Frost** — Ice blue, silver frost, white-blue gradients
