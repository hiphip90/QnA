class Reputation
  class << self
    def update(target_user, delta)
      new_reputation = target_user.reputation + delta
      target_user.with_lock do
        target_user.update(reputation: new_reputation)
      end
    end
  end
end