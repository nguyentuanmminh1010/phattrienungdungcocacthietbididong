package com.nguyentuanminh.test.config;

import com.nguyentuanminh.test.entity.Category;
import com.nguyentuanminh.test.entity.Product;
import com.nguyentuanminh.test.entity.StaffAccount;
import com.nguyentuanminh.test.entity.Tag;
import com.nguyentuanminh.test.entity.User;
import com.nguyentuanminh.test.repository.CategoryRepository;
import com.nguyentuanminh.test.repository.ProductRepository;
import com.nguyentuanminh.test.repository.StaffAccountRepository;
import com.nguyentuanminh.test.repository.TagRepository;
import com.nguyentuanminh.test.repository.UserRepository;
import com.nguyentuanminh.test.entity.Attribute;
import com.nguyentuanminh.test.entity.AttributeValue;
import com.nguyentuanminh.test.entity.ProductAttributeValue;
import com.nguyentuanminh.test.repository.AttributeRepository;
import com.nguyentuanminh.test.repository.AttributeValueRepository;
import com.nguyentuanminh.test.repository.ProductTagRepository;
import com.nguyentuanminh.test.repository.ProductCategoryRepository;
import com.nguyentuanminh.test.entity.ProductTag;
import com.nguyentuanminh.test.entity.ProductCategory;
import com.nguyentuanminh.test.repository.ProductAttributeValueRepository;
import com.nguyentuanminh.test.entity.Coupon;
import com.nguyentuanminh.test.repository.CouponRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;
import org.springframework.jdbc.core.JdbcTemplate;

@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final ProductRepository productRepository;
    private final TagRepository tagRepository;
    private final StaffAccountRepository staffAccountRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final AttributeRepository attributeRepository;
    private final AttributeValueRepository attributeValueRepository;
    private final ProductTagRepository productTagRepository;
    private final ProductCategoryRepository productCategoryRepository;
    private final ProductAttributeValueRepository productAttributeValueRepository;
    private final CouponRepository couponRepository;
    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        // Bỏ việc tự động TRUNCATE để không làm thay đổi UUID của product mỗi khi restart server.
        // Chỉ thêm dữ liệu nếu chưa có.
        if (productRepository.count() > 0) {
            System.out.println("====== DỮ LIỆU ĐÃ CÓ SẴN, BỎ QUA SEED ======");
            return;
        }

        if (couponRepository.count() == 0) {
            couponRepository.saveAll(List.of(
                    Coupon.builder().code("mypromocode2020").title("Personal offer").discountPercentage(10).daysRemaining(6).build(),
                    Coupon.builder().code("summer2020").title("Summer Sale").discountPercentage(15).daysRemaining(23).build(),
                    Coupon.builder().code("welcome10").title("Welcome Bonus").discountPercentage(10).daysRemaining(30).build()
            ));
        }

        if (categoryRepository.count() == 0) {
            // MAIN CATEGORIES
            Category women = Category.builder().categoryName("Women").build();
            Category men = Category.builder().categoryName("Men").build();
            Category kids = Category.builder().categoryName("Kids").build();
            categoryRepository.saveAll(List.of(women, men, kids));

            // WOMEN SUB-CATEGORIES
            Category wNew = Category.builder().categoryName("New").parent(women)
                    .imageUrl("assets/images/image_e5052118244e.png").build();
            Category wClothes = Category.builder().categoryName("Clothes").parent(women)
                    .imageUrl("assets/images/image_f33bdda65e5d.png").build();
            Category wShoes = Category.builder().categoryName("Shoes").parent(women)
                    .imageUrl("assets/images/image_bf7ffeffdaef.png").build();
            Category wAccessories = Category.builder().categoryName("Accessories").parent(women)
                    .imageUrl("assets/images/image_e8df0a37ba28.png").build();
            categoryRepository.saveAll(List.of(wNew, wClothes, wShoes, wAccessories));

            // MEN SUB-CATEGORIES
            Category mNew = Category.builder().categoryName("New").parent(men)
                    .imageUrl("assets/images/image_3204f6279dde.png").build();
            Category mClothes = Category.builder().categoryName("Clothes").parent(men)
                    .imageUrl("assets/images/image_9ea348e44110.png").build();
            Category mShoes = Category.builder().categoryName("Shoes").parent(men)
                    .imageUrl("assets/images/image_bf7ffeffdaef.png").build();
            Category mAccessories = Category.builder().categoryName("Accessories").parent(men)
                    .imageUrl("assets/images/image_e8df0a37ba28.png").build();
            categoryRepository.saveAll(List.of(mNew, mClothes, mShoes, mAccessories));

            // KIDS SUB-CATEGORIES
            Category kNew = Category.builder().categoryName("New").parent(kids)
                    .imageUrl("assets/images/image_e5052118244e.png").build();
            Category kClothes = Category.builder().categoryName("Clothes").parent(kids)
                    .imageUrl("assets/images/image_9aa1ba6915f8.png").build();
            Category kShoes = Category.builder().categoryName("Shoes").parent(kids)
                    .imageUrl("assets/images/image_bf7ffeffdaef.png").build();
            Category kAccessories = Category.builder().categoryName("Accessories").parent(kids)
                    .imageUrl("assets/images/image_e8df0a37ba28.png").build();
            categoryRepository.saveAll(List.of(kNew, kClothes, kShoes, kAccessories));

            // WOMEN -> NEW -> SUB
            Category wNewTops = Category.builder().categoryName("Tops").parent(wNew).build();
            Category wNewShirts = Category.builder().categoryName("Shirts & Blouses").parent(wNew).build();
            Category wNewCardigans = Category.builder().categoryName("Cardigans & Sweaters").parent(wNew).build();
            Category wNewKnitwear = Category.builder().categoryName("Knitwear").parent(wNew).build();
            Category wNewBlazers = Category.builder().categoryName("Blazers").parent(wNew).build();
            Category wNewOuterwear = Category.builder().categoryName("Outerwear").parent(wNew).build();
            Category wNewPants = Category.builder().categoryName("Pants").parent(wNew).build();
            Category wNewJeans = Category.builder().categoryName("Jeans").parent(wNew).build();
            Category wNewShorts = Category.builder().categoryName("Shorts").parent(wNew).build();
            Category wNewSkirts = Category.builder().categoryName("Skirts").parent(wNew).build();
            Category wNewDresses = Category.builder().categoryName("Dresses").parent(wNew).build();
            Category wNewSneakers = Category.builder().categoryName("Sneakers").parent(wNew).build();
            Category wNewBoots = Category.builder().categoryName("Boots").parent(wNew).build();
            Category wNewBags = Category.builder().categoryName("Bags").parent(wNew).build();
            Category wNewBelts = Category.builder().categoryName("Belts").parent(wNew).build();
            categoryRepository.saveAll(List.of(wNewTops, wNewShirts, wNewCardigans, wNewKnitwear, wNewBlazers,
                    wNewOuterwear, wNewPants, wNewJeans, wNewShorts, wNewSkirts, wNewDresses, wNewSneakers,
                    wNewBoots, wNewBags, wNewBelts));

            // MEN -> NEW -> SUB
            Category mNewTops = Category.builder().categoryName("Tops").parent(mNew).build();
            Category mNewShirts = Category.builder().categoryName("Shirts & Blouses").parent(mNew).build();
            Category mNewCardigans = Category.builder().categoryName("Cardigans & Sweaters").parent(mNew).build();
            Category mNewKnitwear = Category.builder().categoryName("Knitwear").parent(mNew).build();
            Category mNewBlazers = Category.builder().categoryName("Blazers").parent(mNew).build();
            Category mNewOuterwear = Category.builder().categoryName("Outerwear").parent(mNew).build();
            Category mNewPants = Category.builder().categoryName("Pants").parent(mNew).build();
            Category mNewJeans = Category.builder().categoryName("Jeans").parent(mNew).build();
            Category mNewShorts = Category.builder().categoryName("Shorts").parent(mNew).build();
            Category mNewSneakers = Category.builder().categoryName("Sneakers").parent(mNew).build();
            categoryRepository.saveAll(List.of(mNewTops, mNewShirts, mNewCardigans, mNewKnitwear, mNewBlazers,
                    mNewOuterwear, mNewPants, mNewJeans, mNewShorts, mNewSneakers));

            // KIDS -> NEW -> SUB
            Category kNewTops = Category.builder().categoryName("Tops").parent(kNew).build();
            Category kNewShirts = Category.builder().categoryName("Shirts & Blouses").parent(kNew).build();
            Category kNewPants = Category.builder().categoryName("Pants").parent(kNew).build();
            Category kNewJeans = Category.builder().categoryName("Jeans").parent(kNew).build();
            Category kNewShorts = Category.builder().categoryName("Shorts").parent(kNew).build();
            Category kNewSkirts = Category.builder().categoryName("Skirts").parent(kNew).build();
            Category kNewDresses = Category.builder().categoryName("Dresses").parent(kNew).build();
            Category kNewSneakers = Category.builder().categoryName("Sneakers").parent(kNew).build();
            categoryRepository.saveAll(List.of(kNewTops, kNewShirts, kNewPants, kNewJeans, kNewShorts, kNewSkirts, kNewDresses, kNewSneakers));

            // WOMEN -> CLOTHES -> SUB
            Category wTops = Category.builder().categoryName("Tops").parent(wClothes).build();
            Category wShirts = Category.builder().categoryName("Shirts & Blouses").parent(wClothes).build();
            Category wCardigans = Category.builder().categoryName("Cardigans & Sweaters").parent(wClothes).build();
            Category wKnitwear = Category.builder().categoryName("Knitwear").parent(wClothes).build();
            Category wBlazers = Category.builder().categoryName("Blazers").parent(wClothes).build();
            Category wOuterwear = Category.builder().categoryName("Outerwear").parent(wClothes).build();
            Category wPants = Category.builder().categoryName("Pants").parent(wClothes).build();
            Category wJeans = Category.builder().categoryName("Jeans").parent(wClothes).build();
            categoryRepository
                    .saveAll(List.of(wTops, wShirts, wCardigans, wKnitwear, wBlazers, wOuterwear, wPants, wJeans));

            // WOMEN -> SHOES -> SUB
            Category wSneakers = Category.builder().categoryName("Sneakers").parent(wShoes).build();
            Category wBoots = Category.builder().categoryName("Boots").parent(wShoes).build();
            categoryRepository.saveAll(List.of(wSneakers, wBoots));

            // WOMEN -> ACCESSORIES -> SUB
            Category wBags = Category.builder().categoryName("Bags").parent(wAccessories).build();
            Category wBelts = Category.builder().categoryName("Belts").parent(wAccessories).build();
            categoryRepository.saveAll(List.of(wBags, wBelts));

            // MEN -> CLOTHES -> SUB
            Category mTops = Category.builder().categoryName("Tops").parent(mClothes).build();
            Category mShirts = Category.builder().categoryName("Shirts & Blouses").parent(mClothes).build();
            Category mPants = Category.builder().categoryName("Pants").parent(mClothes).build();
            Category mJeans = Category.builder().categoryName("Jeans").parent(mClothes).build();
            categoryRepository.saveAll(List.of(mTops, mShirts, mPants, mJeans));

            // KIDS -> CLOTHES -> SUB
            Category kTops = Category.builder().categoryName("Tops").parent(kClothes).build();
            Category kShirts = Category.builder().categoryName("Shirts & Blouses").parent(kClothes).build();
            Category kPants = Category.builder().categoryName("Pants").parent(kClothes).build();
            Category kJeans = Category.builder().categoryName("Jeans").parent(kClothes).build();
            categoryRepository.saveAll(List.of(kTops, kShirts, kPants, kJeans));

            // MEN -> SHOES -> SUB
            Category mSneakers = Category.builder().categoryName("Sneakers").parent(mShoes).build();
            Category mBoots = Category.builder().categoryName("Boots").parent(mShoes).build();
            categoryRepository.saveAll(List.of(mSneakers, mBoots));

            // MEN -> ACCESSORIES -> SUB
            Category mBags = Category.builder().categoryName("Bags").parent(mAccessories).build();
            Category mBelts = Category.builder().categoryName("Belts").parent(mAccessories).build();
            Category mWatches = Category.builder().categoryName("Watches").parent(mAccessories).build();
            categoryRepository.saveAll(List.of(mBags, mBelts, mWatches));

            // KIDS -> SHOES -> SUB
            Category kKidsSneakers = Category.builder().categoryName("Sneakers").parent(kShoes).build();
            Category kSandals = Category.builder().categoryName("Sandals").parent(kShoes).build();
            categoryRepository.saveAll(List.of(kKidsSneakers, kSandals));

            // KIDS -> ACCESSORIES -> SUB
            Category kHats = Category.builder().categoryName("Hats").parent(kAccessories).build();
            Category kKidsBags = Category.builder().categoryName("Bags").parent(kAccessories).build();
            categoryRepository.saveAll(List.of(kHats, kKidsBags));

            // TAGS
            Tag newTag = tagRepository.save(Tag.builder().tagName("New").build());
            Tag saleTag = tagRepository.save(Tag.builder().tagName("Sale").build());
            Tag winterTag = tagRepository.save(Tag.builder().tagName("Winter collection").build());
            Tag summerTag = tagRepository.save(Tag.builder().tagName("Summer Sale").build());

            // --- 6 MORE TOPS ---
            Product top1 = Product.builder().productName("Trendy New Top").brand("Mango").salePrice(45.0)
                    .isNewBadge(true).imageUrl("assets/images/image_058c9aa64aa1.png")
                    .imageUrl2("assets/images/image_8ca6a8674408.png").imageUrl3("assets/images/image_af22b45a7aec.png").rating(4.8)
                    .ratingCount(15).build();
            Product top2 = Product.builder().productName("Elegant Red Top").brand("Zara").salePrice(50.0)
                    .isNewBadge(true).imageUrl("assets/images/image_80f2724e7cfc.png")
                    .imageUrl2("assets/images/image_30915cd7242f.png").imageUrl3("assets/images/image_3a97610b113c.png").rating(4.5)
                    .ratingCount(8).build();
            Product top3 = Product.builder().productName("Red Striped Top").brand("OVS").salePrice(43.0)
                    .isNewBadge(true).imageUrl("assets/images/image_fb8c6dd6aa7b.png")
                    .imageUrl2("assets/images/image_3518ad8e5576.png").imageUrl3("assets/images/image_3b91e06ca9b7.png")
                    .rating(4.0).ratingCount(12).build();
            Product top4 = Product.builder().productName("Classic White T-Shirt").brand("Mango").salePrice(30.0)
                    .comparePrice(40.0).discountTag("-25%").imageUrl("assets/images/image_f83e14deeeb0.png")
                    .imageUrl2("assets/images/image_b9357d2c3d12.png").imageUrl3("assets/images/image_fe6d1abc3683.png")
                    .rating(5.0).ratingCount(8).build();
            Product top5 = Product.builder().productName("Summer Crop Top").brand("H&M").salePrice(25.0)
                    .imageUrl("assets/images/image_aab05caad5c5.png").imageUrl2("assets/images/image_9211ad2c3cf7.png")
                    .imageUrl3("assets/images/image_c985f91dbbfe.png").rating(4.2).ratingCount(18).build();
            Product top6 = Product.builder().productName("Basic Black Top").brand("Uniqlo").salePrice(22.0)
                    .comparePrice(30.0).discountTag("-26%").imageUrl("assets/images/image_f2d2718f85ca.png")
                    .imageUrl2("assets/images/image_3337b2ed72f0.png").imageUrl3("assets/images/image_b7be9927e6fc.png").rating(4.9)
                    .ratingCount(40).build();
            Product top7 = Product.builder().productName("Cotton Tank Top").brand("GAP").salePrice(18.0)
                    .imageUrl("assets/images/image_9517c2332e23.png").imageUrl2("assets/images/image_6c58d2b71eff.png")
                    .imageUrl3("assets/images/image_da8346bdb11f.png").rating(4.6).ratingCount(25).build();
            Product top8 = Product.builder().productName("Floral Top").brand("Dorothy Perkins").salePrice(35.0)
                    .imageUrl("assets/images/image_31fb2ee563bc.png").imageUrl2("assets/images/image_35652183afd1.png")
                    .imageUrl3("assets/images/image_542d41ba3291.png").rating(4.1).ratingCount(10).build();

            // --- 6 MORE SHIRTS & BLOUSES ---
            Product shirt1 = Product.builder().productName("Modern New Shirt").brand("H&M").salePrice(38.0)
                    .isNewBadge(true).imageUrl("assets/images/image_e72a9352505d.png")
                    .imageUrl2("assets/images/image_f33746d2d00f.png").imageUrl3("assets/images/image_2ffc2edcca68.png").rating(4.9)
                    .ratingCount(22).build();
            Product shirt2 = Product.builder().productName("Casual Blue Shirt").brand("Uniqlo").salePrice(35.0)
                    .isNewBadge(true).imageUrl("assets/images/image_bc65a753bfe3.png")
                    .imageUrl2("assets/images/image_90106b5449e0.png").imageUrl3("assets/images/image_9ecb205a8208.png").rating(4.6)
                    .ratingCount(12).build();
            Product shirt3 = Product.builder().productName("T-Shirt SPANISH").brand("Mango").salePrice(9.0)
                    .imageUrl("assets/images/image_b4fc8e7b918d.png")
                    .imageUrl2("assets/images/image_49d407d54549.png").imageUrl3("assets/images/image_370bd6cbc5cb.png")
                    .rating(4.0).ratingCount(3).build();
            Product shirt4 = Product.builder().productName("Blouse").brand("Dorothy Perkins").salePrice(14.0)
                    .comparePrice(21.0).discountTag("-20%").imageUrl("assets/images/image_1a44f3369eac.png")
                    .imageUrl2("assets/images/image_a6c1f217b4cf.png").imageUrl3("assets/images/image_905c71737d31.png")
                    .rating(5.0).ratingCount(10).build();
            Product shirt5 = Product.builder().productName("Light blouse").brand("Dorothy Perkins").salePrice(14.0)
                    .comparePrice(21.0).discountTag("-20%")
                    .imageUrl("assets/images/image_7b69d8a88125.png")
                    .imageUrl2("assets/images/image_7b69d8a88125.png")
                    .imageUrl3("assets/images/image_7b69d8a88125.png").rating(5.0).ratingCount(10)
                    .build();
            Product shirt6 = Product.builder().productName("Oversized Shirt").brand("Zara").salePrice(45.0)
                    .isNewBadge(true).imageUrl("assets/images/image_ed8ad926bff6.png")
                    .imageUrl2("assets/images/image_ed8ad926bff6.png")
                    .imageUrl3("assets/images/image_ed8ad926bff6.png").rating(4.7).ratingCount(50).build();
            Product shirt7 = Product.builder().productName("Silk Blouse").brand("Massimo Dutti").salePrice(85.0)
                    .imageUrl("assets/images/image_ded84c8baf5a.png")
                    .imageUrl2("assets/images/image_ded84c8baf5a.png")
                    .imageUrl3("assets/images/image_ded84c8baf5a.png").rating(4.9).ratingCount(14).build();
            Product shirt8 = Product.builder().productName("Denim Shirt").brand("Levi's").salePrice(60.0)
                    .comparePrice(75.0).discountTag("-20%").imageUrl("assets/images/image_283ccdf9acf0.png")
                    .imageUrl2("assets/images/image_283ccdf9acf0.png")
                    .imageUrl3("assets/images/image_283ccdf9acf0.png").rating(4.8).ratingCount(65).build();

            // --- OTHER PRODUCTS ---
            Product p4 = Product.builder().productName("Cozy Beige Cardigan").brand("Zara").salePrice(55.0)
                    .comparePrice(75.0).discountTag("-26%").imageUrl("assets/images/image_9d7d8dcfaee6.png")
                    .imageUrl2("assets/images/image_9d7d8dcfaee6.png")
                    .imageUrl3("assets/images/image_9d7d8dcfaee6.png").rating(4.8).ratingCount(40).build();
            Product p5 = Product.builder().productName("White Knitted Sweater").brand("Mango").salePrice(45.0)
                    .imageUrl("assets/images/image_cc121311fbaf.png")
                    .imageUrl2("assets/images/image_cc121311fbaf.png")
                    .imageUrl3("assets/images/image_cc121311fbaf.png").rating(4.7).ratingCount(34)
                    .build();
            Product p6 = Product.builder().productName("Black Formal Blazer").brand("Zara").salePrice(85.0)
                    .isNewBadge(true).imageUrl("assets/images/image_59597c00481a.png")
                    .imageUrl2("assets/images/image_59597c00481a.png")
                    .imageUrl3("assets/images/image_59597c00481a.png").rating(4.9).ratingCount(80)
                    .build();
            Product p7 = Product.builder().productName("Stylish Winter Coat").brand("Dorothy Perkins").salePrice(120.0)
                    .comparePrice(150.0).discountTag("-20%")
                    .imageUrl("assets/images/image_2d1f7d822b3e.png")
                    .imageUrl2("assets/images/image_2d1f7d822b3e.png")
                    .imageUrl3("assets/images/image_2d1f7d822b3e.png").rating(4.6).ratingCount(56).build();
            Product p8 = Product.builder().productName("Wide Leg Trousers").brand("Uniqlo").salePrice(40.0)
                    .isNewBadge(true).imageUrl("assets/images/image_24706c531e1d.png")
                    .imageUrl2("assets/images/image_24706c531e1d.png")
                    .imageUrl3("assets/images/image_24706c531e1d.png").rating(4.4).ratingCount(15).build();
            Product p9 = Product.builder().productName("Classic Blue Denim Jeans").brand("Levi's").salePrice(60.0)
                    .comparePrice(80.0).discountTag("-25%").imageUrl("assets/images/image_c6698da6f2f0.png")
                    .imageUrl2("assets/images/image_c6698da6f2f0.png")
                    .imageUrl3("assets/images/image_c6698da6f2f0.png").rating(4.8).ratingCount(120).build();
            Product p10 = Product.builder().productName("Running Sneakers").brand("Nike").salePrice(90.0)
                    .isNewBadge(true).imageUrl("assets/images/image_d0a97d6ca0fc.png")
                    .imageUrl2("assets/images/image_d0a97d6ca0fc.png").imageUrl3("assets/images/image_d0a97d6ca0fc.png")
                    .rating(4.7).ratingCount(200).build();
            Product p11 = Product.builder().productName("Leather Ankle Boots").brand("Clarks").salePrice(110.0)
                    .imageUrl("assets/images/image_66ffa8df5665.png")
                    .imageUrl2("assets/images/image_66ffa8df5665.png")
                    .imageUrl3("assets/images/image_66ffa8df5665.png").rating(4.9).ratingCount(45).build();
            Product p12 = Product.builder().productName("Elegant Handbag").brand("Guess").salePrice(75.0)
                    .comparePrice(100.0).discountTag("-25%").imageUrl("assets/images/image_a3e08cf6b5a2.png")
                    .imageUrl2("assets/images/image_a3e08cf6b5a2.png").imageUrl3("assets/images/image_a3e08cf6b5a2.png")
                    .rating(4.6).ratingCount(88).build();
            Product p13 = Product.builder().productName("Classic Leather Belt").brand("Levis").salePrice(30.0)
                    .imageUrl("assets/images/image_a42b3ebeadb6.png")
                    .imageUrl2("assets/images/image_a42b3ebeadb6.png")
                    .imageUrl3("assets/images/image_a42b3ebeadb6.png").rating(4.5).ratingCount(20).build();

            // --- MISSING CATEGORIES ---
            Product pShorts = Product.builder().productName("Summer Denim Shorts").brand("H&M").salePrice(25.0)
                    .isNewBadge(true).imageUrl("assets/images/image_aa565854af4d.png")
                    .imageUrl2("assets/images/image_aa565854af4d.png").imageUrl3("assets/images/image_aa565854af4d.png")
                    .rating(4.7).ratingCount(35).build();
            Product pSkirts = Product.builder().productName("Floral Midi Skirt").brand("Mango").salePrice(35.0)
                    .imageUrl("assets/images/image_ee82b362ef94.png").imageUrl2("assets/images/image_ee82b362ef94.png")
                    .imageUrl3("assets/images/image_ee82b362ef94.png").rating(4.8).ratingCount(15).build();
            Product pDresses = Product.builder().productName("Elegant Evening Dress").brand("Zara").salePrice(85.0)
                    .comparePrice(100.0).discountTag("-15%").imageUrl("assets/images/image_3912d3b21f68.png")
                    .imageUrl2("assets/images/image_3912d3b21f68.png").imageUrl3("assets/images/image_3912d3b21f68.png")
                    .rating(4.9).ratingCount(120).build();

            productRepository.saveAll(List.of(
                    top1, top2, top3, top4, top5, top6, top7, top8,
                    shirt1, shirt2, shirt3, shirt4, shirt5, shirt6, shirt7, shirt8,
                    p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, pShorts, pSkirts, pDresses));

            productTagRepository.save(ProductTag.builder().product(top1).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(top1).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top1).category(wTops).build());
            productTagRepository.save(ProductTag.builder().product(top2).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(top2).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top2).category(wTops).build());
            productTagRepository.save(ProductTag.builder().product(top3).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(top3).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top3).category(wTops).build());
            productTagRepository.save(ProductTag.builder().product(top4).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(top4).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top4).category(wTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top5).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top5).category(wTops).build());
            productTagRepository.save(ProductTag.builder().product(top6).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(top6).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top6).category(wTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top7).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top7).category(wTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top8).category(wNewTops).build());
            productCategoryRepository.save(ProductCategory.builder().product(top8).category(wTops).build());
            productTagRepository.save(ProductTag.builder().product(shirt1).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt1).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt1).category(wShirts).build());
            productTagRepository.save(ProductTag.builder().product(shirt2).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt2).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt2).category(wShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt3).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt3).category(wShirts).build());
            productTagRepository.save(ProductTag.builder().product(shirt4).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt4).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt4).category(wShirts).build());
            productTagRepository.save(ProductTag.builder().product(shirt5).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt5).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt5).category(wShirts).build());
            productTagRepository.save(ProductTag.builder().product(shirt6).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt6).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt6).category(wShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt7).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt7).category(wShirts).build());
            productTagRepository.save(ProductTag.builder().product(shirt8).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt8).category(wNewShirts).build());
            productCategoryRepository.save(ProductCategory.builder().product(shirt8).category(wShirts).build());
            productTagRepository.save(ProductTag.builder().product(p4).tag(saleTag).build());
            productTagRepository.save(ProductTag.builder().product(p4).tag(winterTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p4).category(wCardigans).build());
            productCategoryRepository.save(ProductCategory.builder().product(p4).category(wNewCardigans).build());
            productTagRepository.save(ProductTag.builder().product(p5).tag(winterTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p5).category(wKnitwear).build());
            productCategoryRepository.save(ProductCategory.builder().product(p5).category(wNewKnitwear).build());
            productTagRepository.save(ProductTag.builder().product(p6).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p6).category(wBlazers).build());
            productCategoryRepository.save(ProductCategory.builder().product(p6).category(wNewBlazers).build());
            productTagRepository.save(ProductTag.builder().product(p7).tag(saleTag).build());
            productTagRepository.save(ProductTag.builder().product(p7).tag(winterTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p7).category(wOuterwear).build());
            productCategoryRepository.save(ProductCategory.builder().product(p7).category(wNewOuterwear).build());
            productTagRepository.save(ProductTag.builder().product(p8).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p8).category(wPants).build());
            productCategoryRepository.save(ProductCategory.builder().product(p8).category(wNewPants).build());
            productTagRepository.save(ProductTag.builder().product(p9).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p9).category(wJeans).build());
            productCategoryRepository.save(ProductCategory.builder().product(p9).category(wNewJeans).build());
            productTagRepository.save(ProductTag.builder().product(p10).tag(newTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p10).category(wSneakers).build());
            productCategoryRepository.save(ProductCategory.builder().product(p10).category(wNewSneakers).build());
            productTagRepository.save(ProductTag.builder().product(p11).tag(winterTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p11).category(wBoots).build());
            productCategoryRepository.save(ProductCategory.builder().product(p11).category(wNewBoots).build());
            productTagRepository.save(ProductTag.builder().product(p12).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(p12).category(wBags).build());
            productCategoryRepository.save(ProductCategory.builder().product(p12).category(wNewBags).build());
            productCategoryRepository.save(ProductCategory.builder().product(p13).category(wBelts).build());
            productCategoryRepository.save(ProductCategory.builder().product(p13).category(wNewBelts).build());
            productTagRepository.save(ProductTag.builder().product(pShorts).tag(newTag).build());
            productTagRepository.save(ProductTag.builder().product(pShorts).tag(summerTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(pShorts).category(wNewShorts).build());
            productCategoryRepository.save(ProductCategory.builder().product(pSkirts).category(wNewSkirts).build());
            productTagRepository.save(ProductTag.builder().product(pDresses).tag(saleTag).build());
            productCategoryRepository.save(ProductCategory.builder().product(pDresses).category(wNewDresses).build());

            // --- AUTO GENERATE MEN & KIDS PRODUCTS ---
            Category[] mCategories = {mNewTops, mNewShirts, mNewCardigans, mNewKnitwear, mNewBlazers, mNewOuterwear, mNewPants, mNewJeans, mNewShorts, mNewSneakers, mTops, mShirts, mPants, mJeans, mSneakers, mBoots, mBags, mBelts, mWatches};
            for (Category c : mCategories) {
                for (int i = 1; i <= 2; i++) {
                    Product p = Product.builder()
                            .productName("Men " + c.getCategoryName() + " " + i)
                            .brand("Zara")
                            .salePrice(30.0 + i * 5)
                            .rating(4.5)
                            .ratingCount(10 + i * 2)
                            .imageUrl("placeholder")
                            .imageUrl2("placeholder")
                            .imageUrl3("placeholder")
                            .build();
                    p = productRepository.save(p);
                    productCategoryRepository.save(ProductCategory.builder().product(p).category(c).build());
                }
            }

            Category[] kCategories = {kNewTops, kNewShirts, kNewPants, kNewJeans, kNewShorts, kNewSkirts, kNewDresses, kNewSneakers, kTops, kShirts, kPants, kJeans, kKidsSneakers, kSandals, kHats, kKidsBags};
            for (Category c : kCategories) {
                for (int i = 1; i <= 2; i++) {
                    Product p = Product.builder()
                            .productName("Kids " + c.getCategoryName() + " " + i)
                            .brand("H&M")
                            .salePrice(20.0 + i * 5)
                            .rating(4.8)
                            .ratingCount(20 + i * 5)
                            .imageUrl("placeholder")
                            .imageUrl2("placeholder")
                            .imageUrl3("placeholder")
                            .build();
                    p = productRepository.save(p);
                    productCategoryRepository.save(ProductCategory.builder().product(p).category(c).build());
                }
            }

            // STAFF ACCOUNTS
            if (staffAccountRepository.count() == 0) {
                StaffAccount s1 = StaffAccount.builder().firstName("John").lastName("Doe").email("john@store.com")
                        .passwordHash("hashed_pw").active(true).roleName("Store Administrator").privileges("ALL")
                        .build();
                staffAccountRepository.saveAll(List.of(s1));
            }

            // USERS
            if (userRepository.count() == 0) {
                User u1 = User.builder().name("Customer One").email("cust1@gmail.com").password("pwd").provider("LOCAL")
                        .build();
                userRepository.saveAll(List.of(u1));
            }

            System.out.println(
                    "====== ĐÃ TẠO DỮ LIỆU MẪU (NEW CÓ NHIỀU CATEGORY, THÊM 8 SẢN PHẨM MỖI LOẠI) THÀNH CÔNG ======");
        }

        // Cập nhật lại ảnh do AI tạo nếu DB đã có sẵn
        List<Product> allProducts = productRepository.findAll();
        boolean changed = false;
        
        int urlIndex = 1;
        for (Product p : allProducts) {
            String img = "https://picsum.photos/seed/" + urlIndex + "/400/600";
            if (!img.equals(p.getImageUrl())) {
                p.setImageUrl(img);
                p.setImageUrl2(img);
                p.setImageUrl3(img);
                changed = true;
            }
            urlIndex++;
        }
        
        if (changed) {
            productRepository.saveAll(allProducts);
            System.out.println("====== ĐÃ CẬP NHẬT ẢNH MỚI (PICSUM) CHO TẤT CẢ SẢN PHẨM ======");
        }

        if (attributeRepository.count() == 0) {
            Attribute sizeAttr = attributeRepository.save(Attribute.builder().attributeName("Size").build());
            Attribute colorAttr = attributeRepository.save(Attribute.builder().attributeName("Color").build());

            AttributeValue sizeS = attributeValueRepository
                    .save(AttributeValue.builder().value("S").attribute(sizeAttr).build());
            AttributeValue sizeM = attributeValueRepository
                    .save(AttributeValue.builder().value("M").attribute(sizeAttr).build());
            AttributeValue sizeL = attributeValueRepository
                    .save(AttributeValue.builder().value("L").attribute(sizeAttr).build());
            AttributeValue sizeXL = attributeValueRepository
                    .save(AttributeValue.builder().value("XL").attribute(sizeAttr).build());

            AttributeValue colorBlack = attributeValueRepository
                    .save(AttributeValue.builder().value("Black").attribute(colorAttr).build());
            AttributeValue colorWhite = attributeValueRepository
                    .save(AttributeValue.builder().value("White").attribute(colorAttr).build());
            AttributeValue colorRed = attributeValueRepository
                    .save(AttributeValue.builder().value("Red").attribute(colorAttr).build());

            for (Product p : allProducts) {
                if (p.getDescription() == null || p.getDescription().isEmpty()) {
                    p.setDescription("High quality product from " + p.getBrand()
                            + ". Designed for maximum comfort and style. Made from premium materials ensuring durability and elegance.");
                }
                productAttributeValueRepository
                        .save(ProductAttributeValue.builder().product(p).attributeValue(sizeS).build());
                productAttributeValueRepository
                        .save(ProductAttributeValue.builder().product(p).attributeValue(sizeM).build());
                productAttributeValueRepository
                        .save(ProductAttributeValue.builder().product(p).attributeValue(sizeL).build());

                productAttributeValueRepository
                        .save(ProductAttributeValue.builder().product(p).attributeValue(colorBlack).build());
                productAttributeValueRepository
                        .save(ProductAttributeValue.builder().product(p).attributeValue(colorWhite).build());
            }
            productRepository.saveAll(allProducts);
            System.out.println("====== ĐÃ TẠO DỮ LIỆU ATTRIBUTE (SIZE, COLOR) VÀ DESCRIPTION ======");
        }
    }
}
