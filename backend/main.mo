import Bool "mo:base/Bool";

import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the ShoppingItem type
  type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Store shopping items
  stable var items : [ShoppingItem] = [];
  stable var nextId : Nat = 0;

  // Add a new item to the list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    items := Array.append(items, [{id; text; completed = false}]);
    nextId += 1;
    id
  };

  // Update an item's completion status
  public func toggleComplete(id: Nat) : async Bool {
    items := Array.map<ShoppingItem, ShoppingItem>(
      items,
      func (item) {
        if (item.id == id) {
          {id = item.id; text = item.text; completed = not item.completed}
        } else {
          item
        }
      }
    );
    true
  };

  // Delete an item from the list
  public func deleteItem(id: Nat) : async Bool {
    let newItems = Array.filter<ShoppingItem>(
      items,
      func (item) { item.id != id }
    );
    if (newItems.size() < items.size()) {
      items := newItems;
      true
    } else {
      false
    }
  };

  // Get all items
  public query func getItems() : async [ShoppingItem] {
    items
  };
}
