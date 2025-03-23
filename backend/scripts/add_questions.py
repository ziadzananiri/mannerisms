from app.models import Question
from app.database import connect_db
from datetime import datetime
from collections import defaultdict

def add_questions():
    # Initialize database connection
    connect_db()

    # Clear existing questions
    Question.objects.delete()
    print("Cleared existing questions")

    # Track category counts per culture for tag generation
    category_counts = defaultdict(lambda: defaultdict(int))

    cultures = {
        "western": "Western",
        "east_asian": "East Asian",
        "south_asian": "South Asian",
        "middle_eastern": "Middle Eastern"
    }

    questions = [
        # Western Culture Questions
        {
            "question": "In Western professional settings, what is the most appropriate greeting?",
            "options": [
                "A firm handshake with direct eye contact",
                "A hug and kiss on both cheeks",
                "A casual wave and 'hey'",
                "A bow with hands clasped"
            ],
            "correct_answer": "A firm handshake with direct eye contact",
            "explanation": "In Western professional settings, a firm handshake with direct eye contact is considered the most appropriate greeting. It conveys confidence, respect, and professionalism.",
            "category": "Greetings",
            "difficulty": "Easy",
            "culture": "western",
            "tag": "Greetings - 1"
        },
        {
            "question": "In Western business culture, what is considered appropriate regarding punctuality?",
            "options": [
                "Arrive 5-10 minutes early",
                "Arrive exactly on time",
                "Arrive 5-10 minutes late",
                "Arrive whenever convenient"
            ],
            "correct_answer": "Arrive 5-10 minutes early",
            "explanation": "In Western business culture, arriving 5-10 minutes early is considered professional and respectful. It shows you value others' time and are well-prepared.",
            "category": "Punctuality",
            "difficulty": "Easy",
            "culture": "western",
            "tag": "Punctuality - 1"
        },
        {
            "question": "When dining at a formal Western restaurant, which utensil should you use first?",
            "options": [
                "Start from the outside and work your way in",
                "Start from the inside and work your way out",
                "Use any utensil you prefer",
                "Wait for others to start"
            ],
            "correct_answer": "Start from the outside and work your way in",
            "explanation": "In Western dining etiquette, you should start with the utensils farthest from your plate and work your way inward with each course.",
            "category": "Dining",
            "difficulty": "Medium",
            "culture": "western",
            "tag": "Dining - 1"
        },
        {
            "question": "In Western workplaces, what is the appropriate way to address your supervisor?",
            "options": [
                "Use their first name unless told otherwise",
                "Always use 'Mr.' or 'Ms.' with their last name",
                "Use 'Sir' or 'Ma'am'",
                "Use their title followed by their last name"
            ],
            "correct_answer": "Use their first name unless told otherwise",
            "explanation": "Western workplaces generally follow a more egalitarian approach. Using first names is common unless specifically told otherwise or in very formal settings.",
            "category": "Workplace",
            "difficulty": "Medium",
            "culture": "western",
            "tag": "Workplace - 1"
        },
        {
            "question": "When attending a Western-style wedding, what is the appropriate gift-giving etiquette?",
            "options": [
                "Give a gift from the registry or cash in a card",
                "Bring a homemade gift only",
                "Give a gift worth at least $500",
                "Gifts are optional"
            ],
            "correct_answer": "Give a gift from the registry or cash in a card",
            "explanation": "In Western wedding etiquette, it's customary to give a gift from the couple's registry or cash in a card. The gift should be thoughtful but not necessarily extravagant.",
            "category": "Gift Giving",
            "difficulty": "Medium",
            "culture": "western",
            "tag": "Gift Giving - 1"
        },

        # East Asian Culture Questions
        {
            "question": "In East Asian business settings, what is the most appropriate greeting?",
            "options": [
                "A slight bow with hands at sides",
                "A firm handshake",
                "A hug",
                "A high-five"
            ],
            "correct_answer": "A slight bow with hands at sides",
            "explanation": "In East Asian business culture, a slight bow is the traditional and respectful way to greet others. The depth of the bow can vary based on seniority and formality.",
            "category": "Greetings",
            "difficulty": "Easy",
            "culture": "east_asian",
            "tag": "Greetings - 1"
        },
        {
            "question": "When attending a formal East Asian dinner, what should you do with chopsticks when not eating?",
            "options": [
                "Place them parallel on the chopstick rest",
                "Stick them vertically in rice",
                "Cross them on the plate",
                "Leave them on the table"
            ],
            "correct_answer": "Place them parallel on the chopstick rest",
            "explanation": "In East Asian dining etiquette, chopsticks should be placed parallel on the chopstick rest when not in use. Sticking them vertically in rice is considered disrespectful as it resembles funeral rituals.",
            "category": "Dining",
            "difficulty": "Medium",
            "culture": "east_asian",
            "tag": "Dining - 1"
        },
        {
            "question": "In East Asian business meetings, what is the appropriate way to present a business card?",
            "options": [
                "Present with both hands and a slight bow",
                "Toss it across the table",
                "Hand it with one hand",
                "Leave it on the table"
            ],
            "correct_answer": "Present with both hands and a slight bow",
            "explanation": "Business cards (meishi) are presented with both hands and a slight bow in East Asian business culture. This shows respect and proper etiquette.",
            "category": "Business",
            "difficulty": "Easy",
            "culture": "east_asian",
            "tag": "Business - 1"
        },
        {
            "question": "When visiting someone's home in East Asia, what should you do with your shoes?",
            "options": [
                "Remove them before entering",
                "Wipe them on the doormat",
                "Keep them on",
                "Take them off only in certain rooms"
            ],
            "correct_answer": "Remove them before entering",
            "explanation": "In East Asian homes, it's customary to remove shoes before entering. This is a sign of respect and helps maintain cleanliness.",
            "category": "Social",
            "difficulty": "Easy",
            "culture": "east_asian",
            "tag": "Social - 1"
        },
        {
            "question": "In East Asian gift-giving, what is considered appropriate?",
            "options": [
                "Give gifts in even numbers",
                "Give gifts in odd numbers",
                "Give gifts in any number",
                "Avoid giving gifts"
            ],
            "correct_answer": "Give gifts in even numbers",
            "explanation": "In East Asian culture, gifts are typically given in even numbers as odd numbers are associated with funerals. The number 4 is particularly avoided as it sounds like 'death' in some languages.",
            "category": "Gift Giving",
            "difficulty": "Medium",
            "culture": "east_asian",
            "tag": "Gift Giving - 1"
        },

        # South Asian Culture Questions
        {
            "question": "In South Asian culture, what is the traditional greeting gesture?",
            "options": [
                "Namaste with folded hands",
                "A firm handshake",
                "A hug",
                "A high-five"
            ],
            "correct_answer": "Namaste with folded hands",
            "explanation": "The traditional greeting in South Asian culture is 'Namaste' with folded hands (anjali mudra). This gesture shows respect and humility.",
            "category": "Greetings",
            "difficulty": "Easy",
            "culture": "south_asian",
            "tag": "Greetings - 1"
        },
        {
            "question": "When dining in South Asian culture, what is the appropriate way to eat?",
            "options": [
                "Use your right hand only",
                "Use both hands",
                "Use utensils only",
                "Use any method"
            ],
            "correct_answer": "Use your right hand only",
            "explanation": "In South Asian dining etiquette, it's traditional to eat with the right hand only, as the left hand is considered unclean. However, utensils are also commonly used in formal settings.",
            "category": "Dining",
            "difficulty": "Medium",
            "culture": "south_asian",
            "tag": "Dining - 1"
        },
        {
            "question": "In South Asian business meetings, what is the appropriate way to address elders?",
            "options": [
                "Use 'Sir' or 'Madam' with respect",
                "Use their first name",
                "Use their last name only",
                "Use any form of address"
            ],
            "correct_answer": "Use 'Sir' or 'Madam' with respect",
            "explanation": "In South Asian business culture, showing respect to elders is crucial. Using 'Sir' or 'Madam' is appropriate, and sometimes adding 'ji' (in India) or 'sahib' (in Pakistan) shows extra respect.",
            "category": "Business",
            "difficulty": "Easy",
            "culture": "south_asian",
            "tag": "Business - 1"
        },
        {
            "question": "When visiting a South Asian home, what should you bring?",
            "options": [
                "Sweets or fruits",
                "Wine or alcohol",
                "Money",
                "Nothing"
            ],
            "correct_answer": "Sweets or fruits",
            "explanation": "When visiting a South Asian home, it's customary to bring sweets or fruits as a gift. Alcohol is generally not appropriate as a gift in traditional households.",
            "category": "Social",
            "difficulty": "Easy",
            "culture": "south_asian",
            "tag": "Social - 1"
        },
        {
            "question": "In South Asian culture, what is the appropriate way to show respect to elders?",
            "options": [
                "Touch their feet or bow slightly",
                "Shake their hand",
                "Hug them",
                "Wave at them"
            ],
            "correct_answer": "Touch their feet or bow slightly",
            "explanation": "In South Asian culture, touching the feet of elders or bowing slightly is a traditional way to show respect and seek their blessings.",
            "category": "Respect",
            "difficulty": "Medium",
            "culture": "south_asian",
            "tag": "Respect - 1"
        },

        # Middle Eastern Culture Questions
        {
            "question": "In Middle Eastern business settings, what is the most appropriate greeting?",
            "options": [
                "A warm handshake with eye contact",
                "A hug and kiss on both cheeks",
                "A casual wave",
                "A nod only"
            ],
            "correct_answer": "A warm handshake with eye contact",
            "explanation": "In Middle Eastern business culture, a warm handshake with eye contact is the standard greeting. The handshake may be held longer than in Western cultures.",
            "category": "Greetings",
            "difficulty": "Easy",
            "culture": "middle_eastern",
            "tag": "Greetings - 1"
        },
        {
            "question": "When dining in Middle Eastern culture, what is the appropriate way to eat?",
            "options": [
                "Use your right hand only",
                "Use both hands",
                "Use utensils only",
                "Use any method"
            ],
            "correct_answer": "Use your right hand only",
            "explanation": "In Middle Eastern dining etiquette, it's traditional to eat with the right hand only, as the left hand is considered unclean. However, utensils are commonly used in formal settings.",
            "category": "Dining",
            "difficulty": "Medium",
            "culture": "middle_eastern",
            "tag": "Dining - 1"
        },
        {
            "question": "In Middle Eastern business meetings, what is the appropriate way to show respect?",
            "options": [
                "Show patience and avoid rushing",
                "Be direct and quick",
                "Interrupt when needed",
                "Leave early if bored"
            ],
            "correct_answer": "Show patience and avoid rushing",
            "explanation": "Middle Eastern business culture values relationship-building and patience. Rushing through meetings or being too direct can be considered disrespectful.",
            "category": "Business",
            "difficulty": "Medium",
            "culture": "middle_eastern",
            "tag": "Business - 1"
        },
        {
            "question": "When visiting a Middle Eastern home, what should you do with your shoes?",
            "options": [
                "Remove them before entering",
                "Wipe them on the doormat",
                "Keep them on",
                "Take them off only in certain rooms"
            ],
            "correct_answer": "Remove them before entering",
            "explanation": "In Middle Eastern homes, it's customary to remove shoes before entering. This is a sign of respect and helps maintain cleanliness.",
            "category": "Social",
            "difficulty": "Easy",
            "culture": "middle_eastern",
            "tag": "Social - 1"
        },
        {
            "question": "In Middle Eastern gift-giving, what should you avoid giving?",
            "options": [
                "Alcohol or pork products",
                "Flowers",
                "Chocolate",
                "Books"
            ],
            "correct_answer": "Alcohol or pork products",
            "explanation": "In Middle Eastern culture, alcohol and pork products are not appropriate gifts due to religious restrictions. Flowers, chocolate, and books are generally acceptable.",
            "category": "Gift Giving",
            "difficulty": "Medium",
            "culture": "middle_eastern",
            "tag": "Gift Giving - 1"
        }
    ]

    # Add questions to database
    for q in questions:
        category_counts[q['culture']][q['category']] += 1
        q['tag'] = f"{cultures[q['culture']]} {q['category']} - {category_counts[q['culture']][q['category']]}"
        question = Question(**q)
        question.save()
        print(f"Added question: {q['question']} with tag: {q['tag']}")

if __name__ == "__main__":
    add_questions() 